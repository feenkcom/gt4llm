"
I describe a snippet that was changed: `oldSnippet` and `newSnippet` are its snapshots before and after the change. My status is 'updated'.
"
Class {
	#name : #GtLLepiterSnippetModificationResult,
	#superclass : #GtLLepiterSnippetChangeResult,
	#instVars : [
		'oldSnippet',
		'newSnippet'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #views }
GtLLepiterSnippetModificationResult >> gtViewChangeIcon [
	^ self class modificationIcon
]

{ #category : #initialization }
GtLLepiterSnippetModificationResult >> initialize [
	super initialize.
	status := 'updated'
]

{ #category : #testing }
GtLLepiterSnippetModificationResult >> isContentChanged [
	^ oldSnippet content ~= newSnippet content
]

{ #category : #refactoring }
GtLLepiterSnippetModificationResult >> llmChangeKind [
	^ 'modified snippet'
]

{ #category : #accessing }
GtLLepiterSnippetModificationResult >> locationSnippet [
	^ oldSnippet ifNil: [ newSnippet ]
]

{ #category : #accessing }
GtLLepiterSnippetModificationResult >> newSnippet [
	^ newSnippet
]

{ #category : #accessing }
GtLLepiterSnippetModificationResult >> newSnippet: aSnippetWithContent [
	newSnippet := aSnippetWithContent
]

{ #category : #accessing }
GtLLepiterSnippetModificationResult >> newStateSnippet [
	^ newSnippet
]

{ #category : #accessing }
GtLLepiterSnippetModificationResult >> oldSnippet [
	^ oldSnippet
]

{ #category : #accessing }
GtLLepiterSnippetModificationResult >> oldSnippet: aSnippetWithContent [
	oldSnippet := aSnippetWithContent
]

{ #category : #accessing }
GtLLepiterSnippetModificationResult >> oldStateSnippet [
	^ oldSnippet
]

{ #category : #accessing }
GtLLepiterSnippetModificationResult >> targetSnippet [
	^ newSnippet ifNil: [ oldSnippet ]
]
