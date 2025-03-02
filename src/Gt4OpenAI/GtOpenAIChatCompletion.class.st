Class {
	#name : #GtOpenAIChatCompletion,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'created',
		'model',
		'choices',
		'usage',
		'systemFingerprint'
	],
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAIChatCompletion class >> serializationProperties [
	^ {#id -> #id.
		#created -> #created.
		#model -> #model.
		#choices -> #choices.
		#usage -> #usage.
		#system_fingerprint -> #systemFingerprint}
]

{ #category : #accessing }
GtOpenAIChatCompletion >> choices [
	^ choices
]

{ #category : #accessing }
GtOpenAIChatCompletion >> choices: anObject [
	choices := anObject
			collect: [ :aChoice | GtOpenAIChatCompletionChoice from: aChoice ]
]

{ #category : #accessing }
GtOpenAIChatCompletion >> created [
	^ created
]

{ #category : #accessing }
GtOpenAIChatCompletion >> created: anObject [
	created := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIChatCompletion >> gtChoicesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Choices';
		priority: 1;
		items: [ self choices ];
		column: 'Index' text: #index width: 40;
		column: 'Message' text: [ :aChoice | aChoice message content ];
		column: 'Finish reason' text: #finishReason width: 80
]

{ #category : #accessing }
GtOpenAIChatCompletion >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIChatCompletion >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIChatCompletion >> model [
	^ model
]

{ #category : #accessing }
GtOpenAIChatCompletion >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOpenAIChatCompletion >> systemFingerprint [
	^ systemFingerprint
]

{ #category : #accessing }
GtOpenAIChatCompletion >> systemFingerprint: anObject [
	systemFingerprint := anObject
]

{ #category : #accessing }
GtOpenAIChatCompletion >> usage [
	^ usage
]

{ #category : #accessing }
GtOpenAIChatCompletion >> usage: anObject [
	usage := GtOpenAIUsage from: anObject
]
