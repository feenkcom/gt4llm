Class {
	#name : #GtOllamaModel,
	#superclass : #GtLlmEntity,
	#instVars : [
		'name',
		'model',
		'modifiedAt',
		'size',
		'digest',
		'details'
	],
	#category : #'Gt4Ollama-Models'
}

{ #category : #accessing }
GtOllamaModel class >> serializationProperties [
	^ {#name -> #name.
		#model -> #model.
		#modified_at -> #modifiedAt.
		#size -> #size.
		#digest -> #digest.
		#details -> #details}
]

{ #category : #accessing }
GtOllamaModel >> details [
	^ details
]

{ #category : #accessing }
GtOllamaModel >> details: anObject [
	details := anObject
]

{ #category : #accessing }
GtOllamaModel >> digest [
	^ digest
]

{ #category : #accessing }
GtOllamaModel >> digest: anObject [
	digest := anObject
]

{ #category : #accessing }
GtOllamaModel >> gtPushModelActionFor: anAction [
	<gtAction>
	^ anAction button
		label: 'Publish';
		action: [ :aButton | aButton phlow spawnObject: (self client pushModel: self name) ]
]

{ #category : #accessing }
GtOllamaModel >> model [
	^ model
]

{ #category : #accessing }
GtOllamaModel >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaModel >> modifiedAt [
	^ modifiedAt
]

{ #category : #accessing }
GtOllamaModel >> modifiedAt: anObject [
	modifiedAt := DateAndTime fromString: anObject
]

{ #category : #accessing }
GtOllamaModel >> name [
	^ name
]

{ #category : #accessing }
GtOllamaModel >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtOllamaModel >> size [
	^ size
]

{ #category : #accessing }
GtOllamaModel >> size: anObject [
	size := anObject
]
