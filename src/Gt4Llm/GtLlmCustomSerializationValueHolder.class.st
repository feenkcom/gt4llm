Class {
	#name : #GtLlmCustomSerializationValueHolder,
	#superclass : #GtLlmSerializableValueHolder,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmCustomSerializationValueHolder >> serialize [
	^ self contentValue
]
