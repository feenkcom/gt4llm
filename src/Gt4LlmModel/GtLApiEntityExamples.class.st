"
Examples for OpenAI-compatible completions request entities.
"
Class {
	#name : #GtLApiEntityExamples,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Examples'
}

{ #category : #examples }
GtLApiEntityExamples >> functionCallEntity [
	<gtExample>
	| rawData entity |
	rawData := Dictionary new
		at: 'name' put: 'WebFetch';
		at: 'arguments' put: '{"url":"https://example.com"}';
		yourself.
	entity := GtLFunctionCallEntity rawData: rawData.
	self assert: entity name equals: 'WebFetch'.
	self assert: (entity arguments at: 'url') equals: 'https://example.com'.
	^ entity
]

{ #category : #examples }
GtLApiEntityExamples >> openAiCompletionsRequestEntity [
	<gtExample>
	| rawData entity message content tool |
	rawData := Dictionary new
		at: 'messages' put: { Dictionary new
			at: 'content' put: { Dictionary new
				at: 'text' put: '"Show me the result of calling the WebFetch tool with url https://example.com"';
				at: 'type' put: 'text';
				yourself };
			at: 'role' put: 'user';
			yourself };
		at: 'stream' put: false;
		at: 'reasoning_effort' put: 'low';
		at: 'model' put: 'qwen3.5:9b';
		at: 'tools' put: { Dictionary new
			at: 'function' put: (Dictionary new
				at: 'type' put: 'function';
				at: 'name' put: 'WebFetch';
				at: 'description' put: 'Fetch a single web page by URL and return its content.
	
Example JSON arguments:
{ "url": "https://example.com" }

Example JSON response:
{
  "title": "Example Domain",
	"content": "<!doctype html>...</html>",
  "links": [ "https://example.com" ]
}';
				at: 'parameters' put: (Dictionary new
					at: 'additionalProperties' put: false;
					at: 'properties' put: (Dictionary new
						at: 'url' put: (Dictionary new at: 'type' put: 'string'; yourself);
						yourself);
					at: 'required' put: #('url');
					at: 'type' put: 'object';
					yourself);
				yourself);
			at: 'type' put: 'function';
			yourself };
		yourself.
	entity := GtLOpenAiCompletionsRequestEntity new rawData: rawData.
	self assert: entity messages size equals: 1.
	message := entity messages first.
	self assert: message class equals: GtLOpenAiMessagesEntity.
	self assert: message role equals: 'user'.
	self assert: message content size equals: 1.
	content := message content first.
	self assert: content class equals: GtLOpenAiContentEntity.
	self assert: content text equals: '"Show me the result of calling the WebFetch tool with url https://example.com"'.
	self assert: content type equals: 'text'.
	self assert: entity stream equals: false.
	self assert: entity reasoningEffort equals: 'low'.
	self assert: entity model equals: 'qwen3.5:9b'.
	self assert: entity tools size equals: 1.
	tool := entity tools first.
	self assert: tool class equals: GtLOllamaCompletionsToolCallEntity.
	self assert: tool type equals: 'function'.
	self assert: tool function name equals: 'WebFetch'.
	^ entity
]
