Class {
	#name : #GtLlmParameterDirective,
	#superclass : #GtLlmModelfileDirective,
	#instVars : [
		'value'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmParameterDirective >> directiveKind [
	^ 'PARAMETER'
]

{ #category : #accessing }
GtLlmParameterDirective >> treatText [
	^ self text , ' ' , self value asString
]

{ #category : #accessing }
GtLlmParameterDirective >> value [
	^ value
]

{ #category : #accessing }
GtLlmParameterDirective >> value: anObject [
	value := anObject
]
