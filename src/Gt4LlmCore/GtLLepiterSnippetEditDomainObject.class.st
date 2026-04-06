Class {
	#name : #GtLLepiterSnippetEditDomainObject,
	#superclass : #GtLLepiterSnippetDomainObject,
	#instVars : [
		'oldText'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'llm views' }
GtLLepiterSnippetEditDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLLepiterSnippetEditDomainObject >> oldText [
	^ oldText
]

{ #category : #accessing }
GtLLepiterSnippetEditDomainObject >> oldText: aString [
	oldText := aString
]

{ #category : #magritte }
GtLLepiterSnippetEditDomainObject >> oldTextDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Old text';
		accessor: #oldText;
		beRequired
]
