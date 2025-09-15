Class {
	#name : #GtOllamaRunningModel,
	#superclass : #GtLlmEntity,
	#instVars : [
		'name',
		'model',
		'expiresAt',
		'size',
		'sizeVram',
		'digest',
		'details'
	],
	#category : #Gt4Ollama
}

{ #category : #accessing }
GtOllamaRunningModel class >> leJsonV4Name [

	^ #gtOllamaRunningModel
]

{ #category : #accessing }
GtOllamaRunningModel class >> serializationProperties [
	^ {#name -> #name.
		#model -> #model.
		#expires_at -> #expiresAt.
		#size -> #size.
		#size_vram -> #sizeVram.
		#digest -> #digest.
		#details -> #details}
]

{ #category : #accessing }
GtOllamaRunningModel >> details [
	^ details
]

{ #category : #accessing }
GtOllamaRunningModel >> details: anObject [
	details := anObject
]

{ #category : #accessing }
GtOllamaRunningModel >> digest [
	^ digest
]

{ #category : #accessing }
GtOllamaRunningModel >> digest: anObject [
	digest := anObject
]

{ #category : #accessing }
GtOllamaRunningModel >> expiresAt [
	^ expiresAt
]

{ #category : #accessing }
GtOllamaRunningModel >> expiresAt: anObject [
	expiresAt := DateAndTime fromString: anObject
]

{ #category : #accessing }
GtOllamaRunningModel >> model [
	^ model
]

{ #category : #accessing }
GtOllamaRunningModel >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaRunningModel >> name [
	^ name
]

{ #category : #accessing }
GtOllamaRunningModel >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtOllamaRunningModel >> size [
	^ size
]

{ #category : #accessing }
GtOllamaRunningModel >> size: anObject [
	size := anObject
]

{ #category : #accessing }
GtOllamaRunningModel >> sizeVram [
	^ sizeVram
]

{ #category : #accessing }
GtOllamaRunningModel >> sizeVram: anObject [
	sizeVram := anObject
]
