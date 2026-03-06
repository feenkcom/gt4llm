"
Shared base for textual snippet creation requests.
"
Class {
	#name : #GtLLepiterTextualSnippetCreationRequest,
	#superclass : #GtLLepiterSnippetCreationRequest,
	#instVars : [
		'snippetText'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLLepiterTextualSnippetCreationRequest >> snippetText [
	^ snippetText
]

{ #category : #accessing }
GtLLepiterTextualSnippetCreationRequest >> snippetText: aString [
	snippetText := aString
]
