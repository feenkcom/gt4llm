Class {
	#name : #GtLLepiterAddCodeSnippetTransformationSpecification,
	#superclass : #GtLLepiterAddSnippetTransformationSpecification,
	#instVars : [
		'newSnippetCode'
	],
	#category : 'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLLepiterAddCodeSnippetTransformationSpecification class >> isConcrete [
	^ true
]

{ #category : #accessing }
GtLLepiterAddCodeSnippetTransformationSpecification class >> jsonSchemaLabel [
	^ 'AddCodeSnippet'
]

{ #category : #accessing }
GtLLepiterAddCodeSnippetTransformationSpecification >> newSnippetCode [
	^ newSnippetCode
]

{ #category : #accessing }
GtLLepiterAddCodeSnippetTransformationSpecification >> newSnippetCode: aString [
	newSnippetCode := aString
]

{ #category : #descriptions }
GtLLepiterAddCodeSnippetTransformationSpecification >> newSnippetCodeDescription [
	<magritteDescription>
	
	 ^ MAStringDescription new
		  accessor: #newSnippetCode;
		  comment: 'The Smalltalk source code of this snippet in plain text'
]
