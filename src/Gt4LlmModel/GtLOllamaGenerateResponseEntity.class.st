Class {
	#name : #GtLOllamaGenerateResponseEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOllamaGenerateResponseEntity >> content [

	^ self rawData at: 'response'
]

{ #category : #accessing }
GtLOllamaGenerateResponseEntity >> contentText [

	^ self content
]

{ #category : #accessing }
GtLOllamaGenerateResponseEntity >> created [
	^ self rawData at: 'created_at'
]

{ #category : #accessing }
GtLOllamaGenerateResponseEntity >> model [
	^ self rawData at: 'model'
]
