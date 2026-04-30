Class {
	#name : #GtLString,
	#superclass : #GtLPlainData,
	#instVars : [
		'stringValue'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLString class >> forString: aString [ 
	^ self new 
		stringValue: aString
]

{ #category : #visiting }
GtLString >> acceptVisitor: aVisitor [

	aVisitor visitGtLString: self
]

{ #category : #views }
GtLString >> gtStringValueFor: aView [
	<gtView>
	<gtLlmView>
	^(aView forward)
		title: 'String';
		priority: 1;
		object: [stringValue];
		view: #gtStringFor:
]

{ #category : #'llm views' }
GtLString >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView jsonData
			data: [ self stringValue ]
]

{ #category : #printing }
GtLString >> printOn: aStream [
	aStream 
		print: self stringValue 
]

{ #category : #accessing }
GtLString >> stringValue [
	^stringValue
]

{ #category : #accessing }
GtLString >> stringValue: anObject [
	stringValue := anObject
]
