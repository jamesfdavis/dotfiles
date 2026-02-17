# Shipping at Inference Speed

**Author:** Peter Steinberger
**Source:** https://steipete.me/posts/2025/shipping-at-inference-speed
**Published:** December 28, 2025

## Core Thesis

"Vibe coding" has evolved from a novelty into a production-grade workflow. The
bottleneck in software development is no longer writing code -- it's inference
time and high-level architectural thinking. Most software "shoves data from one
form to another" and doesn't require hard thinking, so AI agents can handle the
bulk of it.

## Key Takeaways

### "I Ship Code I Never Read"
Steinberger confesses that he no longer reads most of the code he ships. He
watches the stream, occasionally inspects key parts, but trusts the agents to
produce correct output. The shift from amazement ("some prompts produced code
that worked") to expectation happened over the course of 2025.

### The GPT-5 Unlock
The "real unlock" was GPT-5. After a few weeks of use, he started trusting the
model more and reading less code. The quality jump made it viable to treat AI
output as production-ready with minimal review.

### Inference Time Is the Bottleneck
The constraint is no longer developer typing speed or even thinking speed -- it's
how fast the LLM generates output and how many tokens are spent on deep
reasoning. The amount of software one person can create is bounded primarily by
inference time.

### Structure Over Correctness
Folder layout, module boundaries, and clear responsibilities matter more than
prompt precision. When the project structure is obvious, agents tend to do the
right thing. When it's not, no amount of prompting fixes the drift. Architecture
is the lever.

### Cross-Referencing Projects
When a problem has already been solved in another project, Steinberger points
Codex at that folder and lets it infer context. This dramatically reduces
prompting effort and avoids re-solving solved problems.

### Documentation-Driven Development
Each project has a `docs/` folder with subsystem and feature documentation. A
global AGENTS file plus a script forces the model to read relevant docs before
acting on certain topics. Documentation becomes the guardrail.

### CLI-First Development
Everything starts as a CLI. Agents can call CLIs directly and verify output,
closing the feedback loop automatically. This is more reliable than UI-first
development where validation requires human eyes.

### Multi-Model Workflow
Different models are used for different tasks and languages (TypeScript, Go,
Swift). No single model dominates every use case -- the workflow is pragmatically
multi-model.

## The Factory Model

Development has shifted from artisanal code-writing to a factory-like production
model. The developer's role is architect, quality controller, and product
thinker. The agents handle implementation. Speed gains are real but depend
heavily on project structure and clear architectural boundaries.

## Bottom Line

The speed at which a solo developer can ship is now "unreal" -- bounded by
inference time rather than human coding speed. The key insight: invest in
structure, documentation, and CLI-first design. These are what make agents
reliable. The code itself is increasingly a commodity.
