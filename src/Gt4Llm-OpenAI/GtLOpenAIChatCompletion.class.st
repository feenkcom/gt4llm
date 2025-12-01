Class {
	#name : #GtLOpenAIChatCompletion,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'created',
		'model',
		'choices',
		'usage',
		'systemFingerprint'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIChatCompletion class >> leJsonV4Name [

	^ #gtOpenAIChatCompletion
]

{ #category : #accessing }
GtLOpenAIChatCompletion class >> serializationProperties [
	^ {#id -> #id.
		#created -> #created.
		#model -> #model.
		#choices -> #choices.
		#usage -> #usage.
		#system_fingerprint -> #systemFingerprint}
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> choices [
	^ choices
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> choices: anObject [
	choices := anObject
			collect: [ :aChoice | GtLOpenAIChatCompletionChoice from: aChoice ]
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> created [
	^ created
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> created: anObject [
	created := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> gtChoicesFor: aView [
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
GtLOpenAIChatCompletion >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> model [
	^ model
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> systemFingerprint [
	^ systemFingerprint
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> systemFingerprint: anObject [
	systemFingerprint := anObject
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> usage [
	^ usage
]

{ #category : #accessing }
GtLOpenAIChatCompletion >> usage: anObject [
	usage := GtLOpenAIUsage from: anObject
]
