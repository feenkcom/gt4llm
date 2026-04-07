Class {
	#name : #GtLStringData,
	#superclass : #GtLPlainData,
	#instVars : [
		'stringValue'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLStringData class >> forString: aString [ 
	^ self new 
		stringValue: aString
]

{ #category : #'llm views' }
GtLStringData >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonData
			data: [ self stringValue ]
]

{ #category : #printing }
GtLStringData >> printOn: aStream [
	aStream 
		print: self stringValue 
]

{ #category : #accessing }
GtLStringData >> stringValue [
	^stringValue
]

{ #category : #accessing }
GtLStringData >> stringValue: anObject [
	stringValue := anObject
]
