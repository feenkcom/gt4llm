Class {
	#name : #GtOllamaThreadMessageExamples,
	#superclass : #GtLlmThreadMessageExamples,
	#category : #'Gt4Ollama-Examples'
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
	self assert: aMessage totalDuration equals: 700536041 nanoSeconds.

	^ aMessage
]

{ #category : #'as yet unclassified' }
GtOllamaThreadMessageExamples >> greetingMessageJson [
	^ NeoJSONObject
		fromString: '[
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.075689Z",
		"done" : false,
		"message" : {
			"content" : "How",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.096721Z",
		"done" : false,
		"message" : {
			"content" : "''s",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.117983Z",
		"done" : false,
		"message" : {
			"content" : " it",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.139361Z",
		"done" : false,
		"message" : {
			"content" : " going",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.16079Z",
		"done" : false,
		"message" : {
			"content" : "?",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.182418Z",
		"done" : false,
		"message" : {
			"content" : " Is",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.204063Z",
		"done" : false,
		"message" : {
			"content" : " there",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.225477Z",
		"done" : false,
		"message" : {
			"content" : " something",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.246717Z",
		"done" : false,
		"message" : {
			"content" : " I",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.267777Z",
		"done" : false,
		"message" : {
			"content" : " can",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.288844Z",
		"done" : false,
		"message" : {
			"content" : " help",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.309901Z",
		"done" : false,
		"message" : {
			"content" : " you",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.330899Z",
		"done" : false,
		"message" : {
			"content" : " with",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.351986Z",
		"done" : false,
		"message" : {
			"content" : " or",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.373066Z",
		"done" : false,
		"message" : {
			"content" : " would",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.393983Z",
		"done" : false,
		"message" : {
			"content" : " you",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.414966Z",
		"done" : false,
		"message" : {
			"content" : " like",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.435911Z",
		"done" : false,
		"message" : {
			"content" : " to",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.456838Z",
		"done" : false,
		"message" : {
			"content" : " chat",
			"role" : "assistant"
		}
	},
	{
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.477814Z",
		"done" : false,
		"message" : {
			"content" : "?",
			"role" : "assistant"
		}
	},
	{
		"eval_count" : 21,
		"prompt_eval_duration" : 236000000,
		"model" : "llama3.1",
		"created_at" : "2025-02-20T10:18:20.498735Z",
		"done" : true,
		"eval_duration" : 423000000,
		"total_duration" : 700536041,
		"message" : {
			"content" : "",
			"role" : "assistant"
		},
		"load_duration" : 39122583,
		"done_reason" : "stop",
		"prompt_eval_count" : 12
	}
]'
]
