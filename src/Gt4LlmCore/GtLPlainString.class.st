Class {
	#name : #GtLPlainString,
	#superclass : #Object,
	#instVars : [
		'string'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLPlainString class >> forString: aString [ 
	^ self new 
		string: aString
]

{ #category : #'llm views' }
GtLPlainString >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonData
			data: [ self string ]
]

{ #category : #printing }
GtLPlainString >> printOn: aStream [
	aStream 
		print: self string 
]

{ #category : #accessing }
GtLPlainString >> string [
	^string
]

{ #category : #accessing }
GtLPlainString >> string: anObject [
	string := anObject
]
