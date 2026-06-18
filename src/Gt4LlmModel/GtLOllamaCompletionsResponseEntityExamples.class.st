"
Examples for Ollama-compatible completions response entities.
"
Class {
	#name : #GtLOllamaCompletionsResponseEntityExamples,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #examples }
GtLOllamaCompletionsResponseEntityExamples >> completionsResponseEntity [
	<gtExample>
	| rawData entity usage choice message toolCall |
	rawData := Dictionary new
		at: 'usage' put: (Dictionary new
			at: 'prompt_tokens' put: 375;
			at: 'completion_tokens' put: 115;
			at: 'total_tokens' put: 490;
			yourself);
		at: 'system_fingerprint' put: 'fp_ollama';
		at: 'created' put: 1781512246;
		at: 'object' put: 'chat.completion';
		at: 'id' put: 'chatcmpl-493';
		at: 'model' put: 'qwen3.5:9b';
		at: 'choices' put: { Dictionary new
			at: 'finish_reason' put: 'tool_calls';
			at: 'index' put: 0;
			at: 'message' put: (Dictionary new
				at: 'content' put: '';
				at: 'reasoning' put: 'The user wants me to show them what happens when I call the WebFetch tool with a specific URL. This is a direct request, so I should proceed with making the API call using the WebFetch function.

I need to use:
- Function name: WebFetch
- Parameter: url = "https://example.com" (the user specified this exactly)

Let me make the function call now.';
				at: 'role' put: 'assistant';
				at: 'tool_calls' put: { Dictionary new
					at: 'type' put: 'function';
					at: 'function' put: (Dictionary new
						at: 'name' put: 'WebFetch';
						at: 'arguments' put: '{"url":"https://example.com"}';
						yourself);
					at: 'id' put: 'call_q0u2tdvg';
					at: 'index' put: 0;
					yourself };
				yourself);
			yourself };
		yourself.
	entity := GtLOllamaCompletionsResponseEntity new rawData: rawData.
	usage := entity usage.
	self assert: usage class equals: GtLOllamaCompletionsUsageEntity.
	self assert: usage promptTokens equals: 375.
	self assert: usage completionTokens equals: 115.
	self assert: usage totalTokens equals: 490.
	self assert: entity systemFingerprint equals: 'fp_ollama'.
	self assert: entity created equals: 1781512246.
	self assert: entity object equals: 'chat.completion'.
	self assert: entity id equals: 'chatcmpl-493'.
	self assert: entity model equals: 'qwen3.5:9b'.
	self assert: entity choices size equals: 1.
	choice := entity choices first.
	self assert: choice class equals: GtLOllamaCompletionsChoiceEntity.
	self assert: choice finishReason equals: 'tool_calls'.
	self assert: choice index equals: 0.
	message := choice message.
	self assert: message class equals: GtLOllamaCompletionsMessageEntity.
	self assert: message content equals: ''.
	self assert: message role equals: 'assistant'.
	self assert: message toolCalls size equals: 1.
	toolCall := message toolCalls first.
	self assert: toolCall class equals: GtLOllamaCompletionsToolCallEntity.
	self assert: toolCall type equals: 'function'.
	self assert: toolCall function name equals: 'WebFetch'.
	self assert: (toolCall function arguments printString) equals: '{"url":"https://example.com"}'.
	self assert: toolCall id equals: 'call_q0u2tdvg'.
	self assert: toolCall index equals: 0.
	^ entity
]
