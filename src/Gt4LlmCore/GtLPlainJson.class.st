Class {
	#name : #GtLPlainJson,
	#superclass : #GtLPlainData,
	#instVars : [
		'jsonValue'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLPlainJson class >> forString: aString [ 
	^ self new 
		jsonValue: aString
]

{ #category : #accessing }
GtLPlainJson >> jsonValue [
	^jsonValue
]

{ #category : #accessing }
GtLPlainJson >> jsonValue: anObject [
	jsonValue := anObject
]

{ #category : #'llm views' }
GtLPlainJson >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonData
			data: [ self jsonValue ]
]

{ #category : #printing }
GtLPlainJson >> printOn: aStream [
	aStream 
		print: self jsonValue 
]
