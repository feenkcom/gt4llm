"
I list a changed Lepiter snippet by its uid. The Lepiter report groups us by database and page.
"
Class {
	#name : #GtLRefactoringSnippetChangeEntry,
	#superclass : #GtLRefactoringChangeEntry,
	#instVars : [
		'snippet'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #converting }
GtLRefactoringSnippetChangeEntry >> addTargetPropertiesTo: aJsonObject [
	aJsonObject at: 'snippetUid' put: self snippetUid
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> database [
	^ self page ifNotNil: [ :aPage | aPage database ]
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> groupKind [
	^ #lepiter
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> page [
	^ snippet page
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> snippet [
	^ snippet
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> snippet: aSnippet [
	snippet := aSnippet
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> snippetUid [
	"The form editLepiterSnippet expects"

	^ snippet uid uidString
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> target [
	^ self snippetUid
]
