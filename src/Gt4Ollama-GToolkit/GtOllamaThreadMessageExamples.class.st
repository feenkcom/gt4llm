Class {
	#name : #GtOllamaThreadMessageExamples,
	#superclass : #Object,
	#category : #'Gt4Ollama-GToolkit'
}

{ #category : #'as yet unclassified' }
GtOllamaThreadMessageExamples >> basicThreadMessage [
	<gtExample>
	| aMessage |
	aMessage := GtOllamaThreadMessage new.

	^ aMessage
]

{ #category : #'as yet unclassified' }
GtOllamaThreadMessageExamples >> greetingMessage [
	<gtExample>
	| aJson aMessage |
	aJson := self greetingMessageJson.
	aMessage := GtOllamaThreadMessage from: aJson.

	self assert: aMessage role equals: 'assistant'.
	self assert: aMessage model equals: 'llama3.1'.
	self assert: aMessage doneReason equals: 'stop'.
	self assert: aMessage totalDuration equals: 1132606042 nanoSeconds.
	self assert: aMessage toolCalls size equals: 1.
	self assert: aMessage toolCalls first name equals: 'lookupDocumentationPage'.

	^ aMessage
]

{ #category : #'as yet unclassified' }
GtOllamaThreadMessageExamples >> greetingMessageJson [
	^ NeoJSONObject
		fromString: '{
	"model" : "llama3.1",
	"created_at" : "2025-02-21T18:55:42.767228Z",
	"message" : {
		"role" : "assistant",
		"content" : "Hi!",
		"tool_calls" : [
			{
				"function" : {
					"name" : "lookupDocumentationPage",
					"arguments" : {
						"pageName" : "GToolkit introduction"
					}
				}
			}
		]
	},
	"done_reason" : "stop",
	"done" : true,
	"total_duration" : 1132606042,
	"load_duration" : 41079209,
	"prompt_eval_count" : 716,
	"prompt_eval_duration" : 632000000,
	"eval_count" : 21,
	"eval_duration" : 456000000
}'
]
