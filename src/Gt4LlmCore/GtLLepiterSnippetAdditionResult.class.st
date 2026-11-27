"
I describe a snippet that was added: `newSnippet` is its snapshot after the change. My status is 'created'.
"
Class {
	#name : #GtLLepiterSnippetAdditionResult,
	#superclass : #GtLLepiterSnippetChangeResult,
	#instVars : [
		'newSnippet'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #views }
GtLLepiterSnippetAdditionResult >> gtViewChangeIcon [
	^ self class additionIcon
]

{ #category : #initialization }
GtLLepiterSnippetAdditionResult >> initialize [
	super initialize.
	status := 'created'
]

{ #category : #refactoring }
GtLLepiterSnippetAdditionResult >> llmChangeEntry [
	"An added snippet has no position before the change: a report lists it after the snippets that were in the page, in the order of the additions"

	^ super llmChangeEntry
		position: nil;
		yourself
]

{ #category : #refactoring }
GtLLepiterSnippetAdditionResult >> llmChangeKind [
	^ 'added snippet'
]

{ #category : #accessing }
GtLLepiterSnippetAdditionResult >> newSnippet [
	^ newSnippet
]

{ #category : #accessing }
GtLLepiterSnippetAdditionResult >> newSnippet: aSnippetWithContent [
	newSnippet := aSnippetWithContent
]

{ #category : #accessing }
GtLLepiterSnippetAdditionResult >> newStateSnippet [
	^ newSnippet
]

{ #category : #accessing }
GtLLepiterSnippetAdditionResult >> targetSnippet [
	^ newSnippet
]
