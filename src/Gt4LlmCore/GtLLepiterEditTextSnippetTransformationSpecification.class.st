Class {
	#name : #GtLLepiterEditTextSnippetTransformationSpecification,
	#superclass : #GtLLepiterEditSnippetTransformationSpecification,
	#instVars : [
		'updatedSnippetText'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLLepiterEditTextSnippetTransformationSpecification class >> isConcrete [
	^ true
]

{ #category : #accessing }
GtLLepiterEditTextSnippetTransformationSpecification class >> jsonSchemaLabel [
	^ 'EditTextSnippet'
]

{ #category : #refactoring }
GtLLepiterEditTextSnippetTransformationSpecification >> asRefactoringIn: aNamespace [
	aNamespace changes
			addChange: (LeSnippetChange new
				snippet: self targetSnippet;
				newSource: self updatedSnippetText content;
				yourself).
	^ nil
]

{ #category : #views }
GtLLepiterEditTextSnippetTransformationSpecification >> gtUpdatedSnippetTextFor: aView [
	<gtView>
	^ aView forward
		title: 'Raw Content';
		priority: 10;
		object: [ updatedSnippetText ];
		view: #gtMarkdownFor:
]

{ #category : #printing }
GtLLepiterEditTextSnippetTransformationSpecification >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream print: self snippetUid.
		aStream << '; '.
		aStream << self updatedSnippetText content ]
]

{ #category : #accessing }
GtLLepiterEditTextSnippetTransformationSpecification >> updatedSnippetText [
	^ updatedSnippetText
]

{ #category : #accessing }
GtLLepiterEditTextSnippetTransformationSpecification >> updatedSnippetText: anObject [
	updatedSnippetText := anObject
]

{ #category : #descriptions }
GtLLepiterEditTextSnippetTransformationSpecification >> updatedSnippetTextDescription [
	<magritteDescription>
	
	^ MAToOneRelationDescription new
			accessor: #updatedSnippetText;
			classes: { GtLMarkdown};
			beRequired
]
