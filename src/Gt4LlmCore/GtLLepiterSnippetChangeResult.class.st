"
I describe a change of one Lepiter snippet, made by a snippet tool or a refactoring, from snapshots ({{gtClass:GtLLepiterSnippetWithContent}}) taken before and after the change. I never hold the live snippet.

My LLM JSON is my `status` and my `targetSnippetReference`, without contents, as for the method results. My diff goes from the old to the new content string ('' when absent).
"
Class {
	#name : #GtLLepiterSnippetChangeResult,
	#superclass : #GtLChangeResult,
	#instVars : [
		'status'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #accessing }
GtLLepiterSnippetChangeResult >> allResults [
	"Return me and the results of the snippets removed with me"

	^ {self}
]

{ #category : #converting }
GtLLepiterSnippetChangeResult >> asDiffElement [
	"The diff from the old to the new content string. The content decides how it is split and styled"

	^ self targetSnippet content
		diffElementFrom: self oldContentString
		to: self newContentString
]

{ #category : #views }
GtLLepiterSnippetChangeResult >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ {'Kind' -> self llmChangeKind.
				'Status' -> self status.
				'Snippet' -> self llmChangeTarget.
				'Shown as' -> self gtViewChangeTarget.
				'Old snippet' -> self oldStateSnippet.
				'New snippet' -> self newStateSnippet.
				'Reference' -> self targetSnippetReference} ];
		column: 'Property'
			text: [ :each | each key ]
			width: 150;
		column: 'Value' text: [ :each | each value ifNil: [ '' ] ];
		send: [ :each | each value ]
]

{ #category : #views }
GtLLepiterSnippetChangeResult >> gtDiffFor: aView [
	<gtView>
	<gtLlmView>
	self targetSnippet ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Diff';
		priority: 5;
		stencil: [ self asDiffElement ]
]

{ #category : #views }
GtLLepiterSnippetChangeResult >> gtLiveSnippetFor: aView [
	"The snippet as it is now, which can differ from my new snapshot if it changed since. Empty for a removed snippet"

	<gtView>
	(self targetSnippetReference
		ifNil: [ false ]
		ifNotNil: [ :aReference | aReference existsInLepiter ])
		ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Current snippet';
		priority: 15;
		object: [ self targetSnippetReference ];
		view: #gtLiveSnippetFor:
]

{ #category : #views }
GtLLepiterSnippetChangeResult >> gtViewChangeTarget [
	"How the views name the snippet: its type, the start of its content (the new one, or the old one for a removal) and its page. llmChangeTarget names it by its uid for the refactoring reports"

	^ self targetSnippet
		ifNil: [ 'snippet' ]
		ifNotNil: [ :aSnapshot | aSnapshot gtViewDescription ]
]

{ #category : #testing }
GtLLepiterSnippetChangeResult >> isLepiterChangeResult [
	^ true
]

{ #category : #testing }
GtLLepiterSnippetChangeResult >> isSnippetRemovalResult [
	^ false
]

{ #category : #refactoring }
GtLLepiterSnippetChangeResult >> llmChangeEntry [
	"The entry records where the snippet was before the change (locationSnippet), so that a report lists the snippets in their order in the page before the change"

	^ (GtLRefactoringSnippetChangeEntry
		fromSnippetWithContent: self locationSnippet)
		kind: self llmChangeKind;
		newSource: (self newStateSnippet ifNotNil: [ :aSnapshot | aSnapshot contentString ]);
		yourself
]

{ #category : #refactoring }
GtLLepiterSnippetChangeResult >> llmChangeTarget [
	"Name the snippet by its uid and page title, as the refactoring changes do. It is the target that the refactoring reports give"

	| aSnapshot |
	aSnapshot := self targetSnippet.
	aSnapshot ifNil: [ ^ 'snippet' ].
	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: 'snippet ';
				nextPutAll: (aSnapshot snippetUid ifNil: [ '' ]).
			aSnapshot pageTitle
				ifNotNil: [ :aTitle | 
					aStream
						nextPutAll: ' in page ';
						nextPutAll: aTitle ] ]
]

{ #category : #'llm views' }
GtLLepiterSnippetChangeResult >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView magritteObject: [ self ]
]

{ #category : #accessing }
GtLLepiterSnippetChangeResult >> locationSnippet [
	"Return the snapshot that tells where the snippet was before the change"

	^ self targetSnippet
]

{ #category : #accessing }
GtLLepiterSnippetChangeResult >> newContentString [
	^ self newStateSnippet
		ifNil: [ '' ]
		ifNotNil: [ :aSnapshot | aSnapshot contentString ]
]

{ #category : #accessing }
GtLLepiterSnippetChangeResult >> newStateSnippet [
	"Return the snapshot after the change, or nil if the snippet no longer exists"

	^ nil
]

{ #category : #accessing }
GtLLepiterSnippetChangeResult >> oldContentString [
	^ self oldStateSnippet
		ifNil: [ '' ]
		ifNotNil: [ :aSnapshot | aSnapshot contentString ]
]

{ #category : #accessing }
GtLLepiterSnippetChangeResult >> oldStateSnippet [
	"Return the snapshot before the change, or nil if the snippet did not exist"

	^ nil
]

{ #category : #printing }
GtLLepiterSnippetChangeResult >> printOn: aStream [
	super printOn: aStream.
	self targetSnippet ifNil: [ ^ self ].
	aStream
		parenthesize: [ aStream
				nextPutAll: self llmChangeTarget;
				nextPutAll: ', ';
				nextPutAll: (self status ifNil: [ '' ]) ]
]

{ #category : #accessing }
GtLLepiterSnippetChangeResult >> status [
	^ status
]

{ #category : #accessing }
GtLLepiterSnippetChangeResult >> status: aString [
	status := aString
]

{ #category : #magritte }
GtLLepiterSnippetChangeResult >> statusDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Status';
		accessor: #status;
		priority: 1;
		beRequired
]

{ #category : #accessing }
GtLLepiterSnippetChangeResult >> targetSnippet [
	"Return the snapshot (GtLLepiterSnippetWithContent) that names the changed snippet"

	^ self subclassResponsibility
]

{ #category : #accessing }
GtLLepiterSnippetChangeResult >> targetSnippetReference [
	^ self targetSnippet ifNotNil: [ :aSnapshot | aSnapshot reference ]
]

{ #category : #magritte }
GtLLepiterSnippetChangeResult >> targetSnippetReferenceDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Snippet';
		accessor: #targetSnippetReference;
		classes: {GtLLepiterSnippetReference};
		priority: 2;
		beRequired
]
