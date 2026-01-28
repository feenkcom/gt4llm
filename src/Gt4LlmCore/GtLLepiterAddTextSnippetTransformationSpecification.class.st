Class {
	#name : #GtLLepiterAddTextSnippetTransformationSpecification,
	#superclass : #GtLLepiterAddSnippetTransformationSpecification,
	#instVars : [
		'newSnippetText'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLLepiterAddTextSnippetTransformationSpecification class >> isConcrete [
	^ true
]

{ #category : #accessing }
GtLLepiterAddTextSnippetTransformationSpecification class >> jsonSchemaLabel [
	^ 'AddTextSnippet'
]

{ #category : #accessing }
GtLLepiterAddTextSnippetTransformationSpecification >> newSnippetText [
	^ newSnippetText
]

{ #category : #accessing }
GtLLepiterAddTextSnippetTransformationSpecification >> newSnippetText: aString [
	newSnippetText := aString
]

{ #category : #descriptions }
GtLLepiterAddTextSnippetTransformationSpecification >> newSnippetTextDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
			accessor: #newSnippetText;
			classes: { GtLMarkdown};
			beRequired
]
