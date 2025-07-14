Class {
    #name : #GtHuggingFaceGenerateResponseAPIClient,
    #superclass : #GtLlmEndpointClient,
    #instVars : [ 'model', 'inputs' ],
    #category : #Gt4HuggingFace
}

{ #category : #accessing }
GtHuggingFaceGenerateResponseAPIClient >> inputs [
    ^ inputs
]

{ #category : #accessing }
GtHuggingFaceGenerateResponseAPIClient >> inputs: aString [
    inputs := aString
]

{ #category : #accessing }
GtHuggingFaceGenerateResponseAPIClient >> model [
    ^ model
]

{ #category : #accessing }
GtHuggingFaceGenerateResponseAPIClient >> model: aModel [
    model := aModel
]

{ #category : #private }
GtHuggingFaceGenerateResponseAPIClient >> entity [
    ^ {'inputs' -> self inputs} asDictionary
]

{ #category : #request }
GtHuggingFaceGenerateResponseAPIClient >> request [
    ^ self client post: ('models/' , self model) withEntity: self entity
]

{ #category : #serialization }
GtHuggingFaceGenerateResponseAPIClient >> serializationClass [
    ^ Dictionary
]
