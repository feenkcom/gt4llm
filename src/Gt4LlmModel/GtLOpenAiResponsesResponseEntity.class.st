Class {
	#name : #GtLOpenAiResponsesResponseEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> content [
	"output is an Array, but only a single final message is currently handled"
	| output contentArray contentDict text |

	output := self output.
	self assert: output size = 1.
	contentArray := output first 
		at: 'content'
		ifAbsent: [ ^ nil ].
	self assert: contentArray size = 1.
	contentDict := contentArray first.
	self assert: (contentDict at: 'type') = 'output_text'.
	text := contentDict at: 'text'.
	^ [ (NeoJSONReader on: text readStream) next ]
		on: Error
		do: [ :ex | text ]
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> created [
	^ self rawData at: 'created'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> id [
	^ self rawData at: 'id'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> model [
	^ self rawData at: 'model'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> object [
	^ self rawData at: 'object'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> output [
	^ self rawData at: 'output'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> systemFingerprint [
	^ self rawData at: 'system_fingerprint'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> usage [
	^ GtLOllamaCompletionsUsageEntity new rawData: (self rawData at: 'usage')
]
