/**
 * Lightweight web access via curl + textutil (macOS built-ins, no API keys)
 *
 * Tools:
 *   google      — Search via DuckDuckGo, returns titles + URLs + snippets
 *   web_fetch   — Fetch a URL, extract readable text
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";
import { execSync } from "node:child_process";
import { writeFileSync, unlinkSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

const UA =
	"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";

function run(cmd: string, timeoutMs = 15_000): string {
	try {
		return execSync(cmd, {
			encoding: "utf-8",
			timeout: timeoutMs,
			maxBuffer: 2 * 1024 * 1024,
			stdio: ["pipe", "pipe", "pipe"],
		}).trim();
	} catch (e: any) {
		return e.stdout?.trim?.() ?? e.message ?? "Command failed";
	}
}

function htmlToText(html: string): string {
	const tmp = join(tmpdir(), `pi-web-${Date.now()}.html`);
	try {
		writeFileSync(tmp, html, "utf-8");
		return run(`textutil -inputencoding UTF-8 -convert txt -stdout "${tmp}"`, 10_000);
	} finally {
		try {
			unlinkSync(tmp);
		} catch {}
	}
}

function truncate(text: string, maxChars = 50_000): string {
	if (text.length <= maxChars) return text;
	return text.slice(0, maxChars) + `\n\n[Truncated — ${maxChars} of ${text.length} chars shown]`;
}

interface SearchResult {
	title: string;
	url: string;
	snippet: string;
}

function parseDDGLite(html: string): SearchResult[] {
	const results: SearchResult[] = [];
	const seen = new Set<string>();

	// DDG lite wraps each result in a table. Extract link + snippet pairs.
	// Links are in <a class='result-link' href="...">title</a>
	// Snippets follow in <td class="result-snippet">...</td>

	// Extract all result links (class uses single or double quotes)
	// href and class can appear in either order
	const linkRegex = /<a[^>]+(?:class=['"]result-link['"][^>]+href="([^"]+)"|href="([^"]+)"[^>]+class=['"]result-link['"])[^>]*>([\s\S]*?)<\/a>/gi;
	const snippetRegex = /class=['"]result-snippet['"][^>]*>([\s\S]*?)<\/td>/gi;

	const links: { url: string; title: string }[] = [];
	let match;
	while ((match = linkRegex.exec(html)) !== null) {
		const url = (match[1] || match[2]).trim();
		const title = match[3].replace(/<[^>]*>/g, "").trim();
		if (url && title && !seen.has(url)) {
			seen.add(url);
			links.push({ url, title });
		}
	}

	const snippets: string[] = [];
	while ((match = snippetRegex.exec(html)) !== null) {
		snippets.push(match[1].replace(/<[^>]*>/g, "").replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&#x27;/g, "'").replace(/&quot;/g, '"').trim());
	}

	for (let i = 0; i < links.length; i++) {
		results.push({
			title: links[i].title,
			url: links[i].url,
			snippet: snippets[i] ?? "",
		});
	}

	return results;
}

export default function (pi: ExtensionAPI) {
	// ─── google (via DuckDuckGo) ─────────────────────────────
	pi.registerTool({
		name: "google",
		label: "Google",
		description:
			"Search the web and return results with titles, URLs, and snippets. " +
			"Use this to find documentation, packages, answers, tutorials, etc.",
		parameters: Type.Object({
			query: Type.String({ description: "Search query" }),
		}),

		async execute(_toolCallId, params) {
			const q = encodeURIComponent(params.query);

			// DuckDuckGo lite — works reliably with curl, no JS needed
			const html = run(
				`curl -s -L --max-time 10 -A "${UA}" -d "q=${q}" "https://lite.duckduckgo.com/lite/"`,
			);

			if (!html || html.length < 500) {
				return {
					content: [{ type: "text", text: "Search failed — no response." }],
					details: {},
					isError: true,
				};
			}

			const results = parseDDGLite(html);

			if (results.length === 0) {
				// Fallback: extract any URLs
				const urls = [...html.matchAll(/href="(https?:\/\/[^"]+)"/g)]
					.map((m) => m[1])
					.filter((u) => !u.includes("duckduckgo"));
				if (urls.length > 0) {
					return {
						content: [
							{
								type: "text",
								text: `Search: "${params.query}" — could not parse results, but found URLs:\n\n${[...new Set(urls)].slice(0, 10).join("\n")}`,
							},
						],
						details: {},
					};
				}
				return {
					content: [{ type: "text", text: `Search: "${params.query}" — no results found.` }],
					details: {},
				};
			}

			const formatted = results
				.map((r, i) => `${i + 1}. ${r.title}\n   ${r.url}${r.snippet ? `\n   ${r.snippet}` : ""}`)
				.join("\n\n");

			return {
				content: [
					{
						type: "text",
						text: `Search: "${params.query}" — ${results.length} results:\n\n${formatted}`,
					},
				],
				details: { results },
			};
		},
	});

	// ─── web_fetch ───────────────────────────────────────────
	pi.registerTool({
		name: "web_fetch",
		label: "Web Fetch",
		description:
			"Fetch a URL and extract readable text content. " +
			"Works with documentation, articles, READMEs, API docs, etc. " +
			"For GitHub files, prefer raw.githubusercontent.com for clean markdown. " +
			"For JS-heavy SPAs that return empty content, try a different URL or the raw source on GitHub.",
		parameters: Type.Object({
			url: Type.String({ description: "URL to fetch" }),
			raw: Type.Optional(
				Type.Boolean({
					description: "Return raw response without HTML-to-text conversion",
					default: false,
				}),
			),
		}),

		async execute(_toolCallId, params) {
			const { url, raw } = params;

			const isRawText =
				raw ||
				url.includes("raw.githubusercontent.com") ||
				/\.(md|txt|json|ya?ml|toml|xml|csv|tsx?|jsx?|py|rs|go|sh|rb|c|h|css)(\?|$)/i.test(url);

			const response = run(
				`curl -s -L --max-time 15 -A "${UA}" -w "\\n---HTTP:%{http_code}---" "${url}"`,
			);

			const statusMatch = response.match(/---HTTP:(\d+)---$/);
			const status = statusMatch ? parseInt(statusMatch[1]) : 0;
			const body = response.replace(/\n---HTTP:\d+---$/, "");

			if (status >= 400 || !body) {
				return {
					content: [
						{ type: "text", text: `Failed to fetch ${url} — HTTP ${status || "no response"}` },
					],
					details: { status },
					isError: true,
				};
			}

			let text: string;
			if (isRawText) {
				text = body;
			} else {
				text = htmlToText(body);
				text = text.replace(/\n{4,}/g, "\n\n\n").trim();
			}

			if (!text) {
				return {
					content: [
						{
							type: "text",
							text: `Fetched ${url} (HTTP ${status}) but no readable text extracted. The page may require JavaScript. Try the raw source or a different URL.`,
						},
					],
					details: { status },
				};
			}

			text = truncate(text);

			return {
				content: [{ type: "text", text: `${url} (HTTP ${status}):\n\n${text}` }],
				details: { status, length: text.length },
			};
		},
	});
}
