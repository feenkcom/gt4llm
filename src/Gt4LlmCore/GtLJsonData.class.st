Class {
	#name : #GtLJsonData,
	#superclass : #GtLPlainData,
	#instVars : [
		'jsonValue'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLJsonData class >> forString: aString [ 
	^ self new 
		jsonValue: aString
]

{ #category : #accessing }
GtLJsonData >> jsonValue [
	^jsonValue
]

{ #category : #accessing }
GtLJsonData >> jsonValue: anObject [
	jsonValue := anObject
]

{ #category : #'llm views' }
GtLJsonData >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonData
			data: [ self jsonValue ]
]

{ #category : #printing }
GtLJsonData >> printOn: aStream [
	aStream 
		print: self jsonValue 
]
