Class {
	#name : #GtLOpenAiResponsesResponseEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> choices [
	^ (self rawData at: 'choices') collect: [ :each | GtLOllamaCompletionsChoiceEntity new rawData: each ]
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> content [
	"output is an Array, but only a single final message is currently handled"
	| output contentArray contentArray contentDict text |

	self hasChoices ifTrue: [ ^ nil ].
	output := self output.
	self assert: output size = 1.
	contentArray := output first 
		at: 'content'
		ifAbsent: [ ^ nil ].
	self assert: contentArray size = 1.
	contentArray := output first 
		at: 'content'
		ifAbsent: [ ^ nil ].
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

{ #category : #ui }
GtLOpenAiResponsesResponseEntity >> gtChoicesFor: aView [
	<gtView>

	self hasChoices ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Choices';
		priority: 20;
		items: [ self choices ];
		column: 'Choice' text: [ :choice | choice gtDisplayString ]
]

{ #category : #testing }
GtLOpenAiResponsesResponseEntity >> hasChoices [

	^ self rawData includesKey: 'choices'
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
