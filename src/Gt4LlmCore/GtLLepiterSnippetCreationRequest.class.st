Class {
	#name : #GtLLepiterSnippetCreationRequest,
	#superclass : #Object,
	#instVars : [
		'pageUid',
		'snippetText',
		'snippetType'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> pageUid [
	^ pageUid
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> pageUid: aString [
	pageUid := aString
]

{ #category : #descriptions }
GtLLepiterSnippetCreationRequest >> pageUidDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		beRequired
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> snippetText [
	^ snippetText
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> snippetText: aString [
	snippetText := aString
]

{ #category : #descriptions }
GtLLepiterSnippetCreationRequest >> snippetTextDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Snippet text';
		comment: 'Textual content of the snippet.';
		accessor: #snippetText;
		beRequired
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> snippetType [
	^ snippetType
]

{ #category : #accessing }
GtLLepiterSnippetCreationRequest >> snippetType: aString [
	snippetType := aString
]

{ #category : #descriptions }
GtLLepiterSnippetCreationRequest >> snippetTypeDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Snippet type';
		comment: 'One of text, pharo, python, shell. Defaults to text.';
		accessor: #snippetType
]
