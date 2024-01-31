Class {
	#name : #Gt4OpenAIChatCompletion,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'id',
		'created',
		'model',
		'choices',
		'usage',
		'systemFingerprint'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIChatCompletion class >> serializationProperties [
	^ {#id -> #id.
		#created -> #created.
		#model -> #model.
		#choices -> #choices.
		#usage -> #usage.
		#system_fingerprint -> #systemFingerprint}
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> choices [
	^ choices
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> choices: anObject [
	choices := anObject
			collect: [ :aChoice | Gt4OpenAIChatCompletionChoice from: aChoice ]
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> created [
	^ created
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> created: anObject [
	created := DateAndTime fromUnixTime: anObject
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> gtChoicesFor: aView [
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
Gt4OpenAIChatCompletion >> id [
	^ id
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> id: anObject [
	id := anObject
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> model [
	^ model
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> model: anObject [
	model := anObject
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> systemFingerprint [
	^ systemFingerprint
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> systemFingerprint: anObject [
	systemFingerprint := anObject
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> usage [
	^ usage
]

{ #category : #accessing }
Gt4OpenAIChatCompletion >> usage: anObject [
	usage := Gt4OpenAIUsage from: anObject
]
