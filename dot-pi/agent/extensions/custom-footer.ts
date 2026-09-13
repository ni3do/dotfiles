/**
 * Starship-inspired custom footer
 *
 * Line 1:  ~/path ± ·  branch · ◆ session-name
 * Line 2: ⟳T4 · 12k ↻87% · ⏱2m34s · $0.42 · ████▎░░ 42% 84k/200k    ⚡high · (provider) model
 * Line 3: [extension statuses, if any]
 *
 * Layout rules:
 *  - Right side (thinking · model) is pinned and never truncated.
 *  - Left segments drop by priority (elapsed first, ctx-bar last) when narrow.
 */

import { exec } from "node:child_process";
import { homedir } from "node:os";

import type { AssistantMessage, Usage } from "@mariozechner/pi-ai";
import type { ExtensionAPI, Theme } from "@mariozechner/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";

// ─── formatters ────────────────────────────────────────────────────────────

function shortenPath(cwd: string): string {
	const home = homedir();
	let p = cwd.startsWith(home) ? "~" + cwd.slice(home.length) : cwd;
	const parts = p.split("/");
	if (parts.length <= 3) return p;
	return parts[0] + "/…/" + parts.slice(-2).join("/");
}

function fmtTokens(n: number): string {
	if (n < 1000) return `${n}`;
	if (n < 10_000) return `${(n / 1000).toFixed(1)}k`;
	if (n < 1_000_000) return `${Math.round(n / 1000)}k`;
	if (n < 10_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
	return `${Math.round(n / 1_000_000)}M`;
}

function fmtDuration(ms: number): string {
	const totalSec = Math.floor(ms / 1000);
	if (totalSec < 60) return `${totalSec}s`;
	const min = Math.floor(totalSec / 60);
	const sec = totalSec % 60;
	if (min < 60) return `${min}m${sec.toString().padStart(2, "0")}s`;
	const hr = Math.floor(min / 60);
	const remMin = min % 60;
	return `${hr}h${remMin.toString().padStart(2, "0")}m`;
}

// ─── context bar (eighth-block resolution) ────────────────────────────────

const PARTIAL_BLOCKS = ["", "▏", "▎", "▍", "▌", "▋", "▊", "▉"];

function drawContextBar(
	percent: number | null,
	length: number,
	theme: Theme,
): { bar: string; color: "error" | "warning" | "success" | "muted" } {
	if (percent === null) {
		return {
			bar: theme.fg("dim", "░".repeat(length)),
			color: "muted",
		};
	}
	// Thresholds aligned with auto-compaction zone (~80%)
	const color: "error" | "warning" | "success" =
		percent >= 80 ? "error" : percent >= 60 ? "warning" : "success";

	const eighths = Math.round((percent / 100) * length * 8);
	const fullCells = Math.min(length, Math.floor(eighths / 8));
	const remainder = eighths % 8;
	const hasPartial = fullCells < length && remainder > 0;
	const emptyCells = length - fullCells - (hasPartial ? 1 : 0);

	const filled = "█".repeat(fullCells) + (hasPartial ? PARTIAL_BLOCKS[remainder] : "");
	const empty = "░".repeat(emptyCells);
	return { bar: theme.fg(color, filled) + theme.fg("dim", empty), color };
}

// ─── layout: drop-by-priority fit ─────────────────────────────────────────

interface Segment {
	str: string;
	/** Higher = keep longer. Lowest priority drops first. */
	priority: number;
}

function fitLine(segments: Segment[], right: string, width: number, sep: string): string {
	const sepW = visibleWidth(sep);
	const rightW = visibleWidth(right);

	// Drop lowest-priority segments until it fits. Preserve display order.
	const active = segments.map((s, i) => ({ ...s, idx: i }));
	const sortedByPrio = [...active].sort((a, b) => a.priority - b.priority);

	const tryRender = (segs: typeof active): string | null => {
		if (segs.length === 0) {
			return rightW <= width ? right : null;
		}
		const ordered = [...segs].sort((a, b) => a.idx - b.idx);
		const left = ordered.map((s) => s.str).join(sep);
		const leftW = visibleWidth(left);
		const minTotal = leftW + 1 + rightW;
		if (minTotal > width) return null;
		const gap = Math.max(1, width - leftW - rightW);
		return left + " ".repeat(gap) + right;
	};

	let working = active;
	let rendered = tryRender(working);
	while (rendered === null && sortedByPrio.length > 0) {
		const drop = sortedByPrio.shift()!;
		working = working.filter((s) => s.idx !== drop.idx);
		rendered = tryRender(working);
	}
	if (rendered !== null) return rendered;
	// Right alone doesn't fit either — hard truncate.
	return truncateToWidth(right, width);
}

// ─── git dirty (cached, polled) ────────────────────────────────────────────

function checkDirty(cwd: string): Promise<boolean> {
	return new Promise((resolve) => {
		exec(
			"git status --porcelain --untracked-files=no",
			{ cwd, timeout: 1500, windowsHide: true },
			(err, stdout) => {
				if (err) resolve(false);
				else resolve(stdout.trim().length > 0);
			},
		);
	});
}

// ─── main ──────────────────────────────────────────────────────────────────

export default function (pi: ExtensionAPI) {
	let sessionStart = Date.now();
	let turnCount = 0;
	let inTurn = false;

	pi.on("session_start", async (_event, ctx) => {
		sessionStart = Date.now();
		turnCount = 0;
		inTurn = false;

		// Reconstruct turn count from existing entries
		for (const e of ctx.sessionManager.getEntries()) {
			if (e.type === "message" && e.message.role === "assistant") {
				turnCount++;
			}
		}

		ctx.ui.setFooter((tui, theme, footerData) => {
			const unsub = footerData.onBranchChange(() => tui.requestRender());

			let dirty = false;
			const refreshDirty = () => {
				checkDirty(ctx.cwd).then((d) => {
					if (d !== dirty) {
						dirty = d;
						tui.requestRender();
					}
				});
			};
			refreshDirty();

			// Periodic re-render: elapsed timer + dirty poll
			const timer = setInterval(() => {
				refreshDirty();
				tui.requestRender();
			}, 10_000);

			return {
				dispose() {
					unsub();
					clearInterval(timer);
				},
				invalidate() {},
				render(width: number): string[] {
					const sep = theme.fg("dim", " · ");
					const dot = theme.fg("dim", " • ");

					// ── LINE 1: path ± ·  branch · ◆ session ─────────────
					const dir = shortenPath(ctx.cwd);
					const dirParts = dir.split("/");
					const coloredDir = dirParts
						.map((part, i) => {
							if (part === "…") return theme.fg("dim", "…");
							if (i === dirParts.length - 1) return theme.fg("accent", part);
							return theme.fg("syntaxType", part);
						})
						.join(theme.fg("dim", "/"));
					let line1Left = theme.fg("mdListBullet", " ") + coloredDir;
					if (dirty) line1Left += " " + theme.fg("warning", "±");

					const branch = footerData.getGitBranch();
					if (branch) {
						line1Left += sep + theme.fg("success", "") + " " + theme.fg("syntaxString", branch);
					}

					const sessionName = ctx.sessionManager.getSessionName?.();
					if (sessionName) {
						line1Left += dot + theme.fg("syntaxNumber", "◆") + " " + theme.fg("muted", sessionName);
					}

					// ── LINE 2: telemetry ─────────────────────────────────
					let totalCost = 0;
					let lastUsage: Usage | undefined;
					for (const e of ctx.sessionManager.getEntries()) {
						if (e.type === "message" && e.message.role === "assistant") {
							const m = e.message as AssistantMessage;
							totalCost += m.usage.cost.total;
							lastUsage = m.usage;
						}
					}

					// Turn counter — show in-flight turn as N+1 so it matches user expectation
					const displayTurn = turnCount + (inTurn ? 1 : 0);
					const turnStr =
						theme.fg("syntaxKeyword", "⟳") + " " + theme.fg("syntaxVariable", `T${displayTurn}`);

					// Last-turn breakdown: tokens + cache hit %
					let lastTurnStr: string | null = null;
					if (lastUsage) {
						const inputTotal = lastUsage.input + lastUsage.cacheRead + lastUsage.cacheWrite;
						const turnTokens = inputTotal + lastUsage.output;
						const cachePct = inputTotal > 0
							? Math.round((100 * lastUsage.cacheRead) / inputTotal)
							: null;
						const tokStr = theme.fg("muted", fmtTokens(turnTokens));
						if (cachePct !== null) {
							const cacheColor: "success" | "warning" | "muted" =
								cachePct >= 70 ? "success" : cachePct >= 30 ? "warning" : "muted";
							lastTurnStr =
								tokStr +
								" " +
								theme.fg(cacheColor, "↻") +
								theme.fg(cacheColor, `${cachePct}%`);
						} else {
							lastTurnStr = tokStr;
						}
					}

					// Elapsed
					const elapsed = fmtDuration(Date.now() - sessionStart);
					const elapsedStr = theme.fg("syntaxType", "⏱") + " " + theme.fg("muted", elapsed);

					// Cost — color by spend tier ($5 warn, $20 alarm)
					const usingOAuth = ctx.model ? ctx.modelRegistry.isUsingOAuth(ctx.model) : false;
					const costColor: "syntaxString" | "warning" | "error" =
						totalCost >= 20 ? "error" : totalCost >= 5 ? "warning" : "syntaxString";
					const costVal = `$${totalCost.toFixed(2)}`;
					const costStr =
						theme.fg(costColor, costVal) + (usingOAuth ? theme.fg("dim", " sub") : "");

					// Context bar — eighth-block resolution, width-aware
					const contextUsage = ctx.getContextUsage();
					const contextWindow = contextUsage?.contextWindow ?? ctx.model?.contextWindow ?? 0;
					const pct = contextUsage?.percent ?? null;
					const tokens = contextUsage?.tokens ?? null;

					const barLen = Math.max(6, Math.min(12, Math.floor(width / 30)));
					const { bar } = drawContextBar(pct, barLen, theme);

					let ctxStr: string;
					if (pct === null) {
						// Post-compact / unknown
						ctxStr = bar + " " + theme.fg("dim", "↺ ?");
					} else {
						const ctxColor: "error" | "warning" | "success" =
							pct >= 80 ? "error" : pct >= 60 ? "warning" : "success";
						const usedTok = tokens !== null ? fmtTokens(tokens) : "?";
						const winTok = fmtTokens(contextWindow);
						ctxStr =
							bar +
							" " +
							theme.fg(ctxColor, `${pct.toFixed(0)}%`) +
							theme.fg("dim", ` ${usedTok}/${winTok}`);
					}

					// Assemble left segments with drop priority
					// (lower priority drops first; ctx bar always wins)
					const leftSegs: Segment[] = [
						{ str: turnStr, priority: 3 },
						...(lastTurnStr ? [{ str: lastTurnStr, priority: 2 } as Segment] : []),
						{ str: elapsedStr, priority: 1 },
						{ str: costStr, priority: 4 },
						{ str: ctxStr, priority: 5 },
					];

					// ── Right side: thinking · model (always pinned) ─────
					const rightParts: string[] = [];

					const thinking = pi.getThinkingLevel();
					if (ctx.model?.reasoning) {
						if (thinking === "off") {
							rightParts.push(theme.fg("dim", "⚡off"));
						} else {
							const colorKey = ("thinking" + thinking.charAt(0).toUpperCase() + thinking.slice(1)) as
								| "thinkingMinimal"
								| "thinkingLow"
								| "thinkingMedium"
								| "thinkingHigh"
								| "thinkingXhigh";
							rightParts.push(theme.fg(colorKey, "⚡") + theme.fg(colorKey, thinking));
						}
					} else {
						// Stable layout: dim placeholder for non-reasoning models
						rightParts.push(theme.fg("dim", "⚡—"));
					}

					const model = ctx.model?.id || "no-model";
					const providerCount = footerData.getAvailableProviderCount();
					let modelStr = theme.fg("syntaxNumber", "󰚩 ") + theme.fg("mdHeading", model);
					if (providerCount > 1 && ctx.model) {
						modelStr =
							theme.fg("syntaxPunctuation", "(") +
							theme.fg("syntaxType", ctx.model.provider) +
							theme.fg("syntaxPunctuation", ") ") +
							modelStr;
					}
					rightParts.push(modelStr);

					const line2Right = rightParts.join(sep);
					const line2 = fitLine(leftSegs, line2Right, width, sep);

					const lines = [truncateToWidth(line1Left, width), line2];

					// ── LINE 3: extension statuses ───────────────────────
					const statuses = footerData.getExtensionStatuses();
					if (statuses.size > 0) {
						const sorted = Array.from(statuses.entries())
							.sort(([a], [b]) => a.localeCompare(b))
							.map(([, text]) => text.replace(/[\r\n\t]+/g, " ").replace(/ +/g, " ").trim());
						lines.push(truncateToWidth(sorted.join("  "), width, theme.fg("dim", "…")));
					}

					return lines;
				},
			};
		});
	});

	pi.on("turn_start", async () => {
		inTurn = true;
	});

	pi.on("turn_end", async () => {
		inTurn = false;
		turnCount++;
	});

}

// Note: session_start fires on startup/reload/new/resume/fork (event.reason),
// so we don't need a separate session_switch handler — the handler above
// reconstructs turn state from entries on every session_start.
