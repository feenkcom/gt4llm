Class {
	#name : #GtLPlainTextBasedModel,
	#superclass : #GtLWrappedModel,
	#category : 'Gt4LlmCore-Core'
}

{ #category : #adding }
GtLPlainTextBasedModel >> addContentOneLineSummaryTo: aStringStream [
	model addContentOneLineSummaryTo: aStringStream
]

{ #category : #adding }
GtLPlainTextBasedModel >> addInstructionsTo: aMessageInstructions [
	
]

{ #category : #views }
GtLPlainTextBasedModel >> llmModelDataViewsFor: aDataView [
	<gtLlmDataView>
	
	^aDataView plainText: [ self model ]
]

{ #category : #printing }
GtLPlainTextBasedModel >> printOn: aStream [
	aStream 
		<< 'Plain Text Model: ';
		print: model 
]
