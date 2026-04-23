Class {
	#name : #GtLLepiterAddTextSnippetTransformationSpecification,
	#superclass : #GtLLepiterAddSnippetTransformationSpecification,
	#instVars : [
		'newSnippetText'
	],
	#category : 'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLLepiterAddTextSnippetTransformationSpecification class >> isConcrete [
	^ false
]

{ #category : #accessing }
GtLLepiterAddTextSnippetTransformationSpecification class >> jsonSchemaLabel [
	^ 'AddTextSnippet'
]

{ #category : #views }
GtLLepiterAddTextSnippetTransformationSpecification >> gtNewSnippetTextFor: aView [
	<gtView>
	^ aView forward
		title: 'New snippet';
		priority: 1;
		object: [ newSnippetText ];
		view: #gtMarkdownFor:
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
