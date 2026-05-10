/**
 * Starship-inspired custom footer
 *
 * Line 1:  ~/path ·  branch · session-name
 * Line 2: ⟳T3 · ⏱2m34s · $0.42 · ▰▰▰▱▱▱ 42% 200k ──── ⚡thinking · (provider) model
 * Line 3: [extension statuses, if any]
 */

import type { AssistantMessage } from "@mariozechner/pi-ai";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";
import { homedir } from "node:os";

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

function padBetween(left: string, right: string, width: number): string {
	const gap = Math.max(1, width - visibleWidth(left) - visibleWidth(right));
	return left + " ".repeat(gap) + right;
}

export default function (pi: ExtensionAPI) {
	let sessionStart = Date.now();
	let turnCount = 0;

	pi.on("session_start", async (_event, ctx) => {
		sessionStart = Date.now();
		turnCount = 0;

		// Reconstruct turn count from existing entries
		for (const e of ctx.sessionManager.getEntries()) {
			if (e.type === "message" && e.message.role === "assistant") {
				turnCount++;
			}
		}

		ctx.ui.setFooter((tui, theme, footerData) => {
			const unsub = footerData.onBranchChange(() => tui.requestRender());

			// Tick the elapsed timer every 10s
			const timer = setInterval(() => tui.requestRender(), 10_000);

			return {
				dispose() {
					unsub();
					clearInterval(timer);
				},
				invalidate() {},
				render(width: number): string[] {
					const sep = theme.fg("dim", " · ");
					const dot = theme.fg("dim", " • ");

					// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
					// LINE 1:  path ·  branch · session
					// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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

					const branch = footerData.getGitBranch();
					if (branch) {
						line1Left += sep + theme.fg("success", "") + " " + theme.fg("syntaxString", branch);
					}

					const sessionName = ctx.sessionManager.getSessionName?.();
					if (sessionName) {
						line1Left += dot + theme.fg("syntaxNumber", "◆") + " " + theme.fg("muted", sessionName);
					}

					// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
					// LINE 2: turns · elapsed · cost · context ─── thinking · model
					// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
					let totalCost = 0;
					for (const e of ctx.sessionManager.getEntries()) {
						if (e.type === "message" && e.message.role === "assistant") {
							const m = e.message as AssistantMessage;
							totalCost += m.usage.cost.total;
						}
					}

					// Turn counter
					const turnStr = theme.fg("syntaxKeyword", "⟳") + " " + theme.fg("syntaxVariable", `T${turnCount}`);

					// Elapsed time
					const elapsed = fmtDuration(Date.now() - sessionStart);
					const elapsedStr = theme.fg("syntaxType", "⏱") + " " + theme.fg("muted", elapsed);

					// Cost
					const usingOAuth = ctx.model ? ctx.modelRegistry.isUsingOAuth(ctx.model) : false;
					const costVal = `$${totalCost.toFixed(2)}`;
					const costStr = theme.fg("syntaxString", costVal) + (usingOAuth ? theme.fg("dim", " sub") : "");

					// Context usage — sleek segmented bar ▰▱
					const contextUsage = ctx.getContextUsage();
					const contextWindow = contextUsage?.contextWindow ?? ctx.model?.contextWindow ?? 0;
					const pctValue = contextUsage?.percent ?? 0;

					const ctxColor: "error" | "warning" | "success" =
						pctValue > 90 ? "error" : pctValue > 70 ? "warning" : "success";

					const barLen = 6;
					const filled = Math.round((pctValue / 100) * barLen);
					const barFull = "▰".repeat(filled);
					const barEmpty = "▱".repeat(barLen - filled);
					const barStr = theme.fg(ctxColor, barFull) + theme.fg("dim", barEmpty);

					const pctLabel = contextUsage?.percent !== null ? `${pctValue.toFixed(0)}%` : "?";
					const ctxStr = barStr + " " + theme.fg(ctxColor, pctLabel) + theme.fg("dim", " " + fmtTokens(contextWindow));

					const line2Left = turnStr + sep + elapsedStr + sep + costStr + sep + ctxStr;

					// Right: thinking · model
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
					const line2 = padBetween(line2Left, line2Right, width);

					const lines = [truncateToWidth(line1Left, width), truncateToWidth(line2, width)];

					// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
					// LINE 3: extension statuses (if any)
					// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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

	pi.on("turn_end", async (_event, _ctx) => {
		turnCount++;
	});

	pi.on("session_switch", async (event, ctx) => {
		if (event.reason === "new") {
			sessionStart = Date.now();
			turnCount = 0;
		} else {
			// Resuming — reconstruct turn count
			turnCount = 0;
			for (const e of ctx.sessionManager.getEntries()) {
				if (e.type === "message" && e.message.role === "assistant") {
					turnCount++;
				}
			}
		}
	});
}
