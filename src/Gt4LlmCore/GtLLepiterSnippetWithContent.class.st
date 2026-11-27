"
I am a snapshot of a Lepiter snippet: its reference ({{gtClass:GtLLepiterSnippetReference}}), type, content ({{gtClass:GtLLepiterSnippetContent}}), the title of its page, the name of its database, the uid of its parent snippet (nil for a top-level snippet) and its depth-first position in the page (1 for the first snippet).

I hold no live snippet: I describe the snippet as it was when I was taken. Build me with {{gtMethod:GtLLepiterSnippetWithContent class>>#fromSnippet:}}.
"
Class {
	#name : #GtLLepiterSnippetWithContent,
	#superclass : #Object,
	#instVars : [
		'reference',
		'snippetType',
		'content',
		'pageTitle',
		'databaseName',
		'parentSnippetUid',
		'position'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLLepiterSnippetWithContent class >> fromSnippet: aSnippet [
	"Take a snapshot of aSnippet, which must have a uid (be in a page)"

	^ self new
		initializeFromSnippet: aSnippet;
		yourself
]

{ #category : #accessing }
GtLLepiterSnippetWithContent class >> positionOf: aSnippet inPage: aPage [
	"Return the depth-first position of aSnippet in aPage (1 for the first snippet), or nil"

	| anIndex |
	anIndex := 0.
	aPage
		allChildrenDepthFirstDo: [ :each | 
			anIndex := anIndex + 1.
			each == aSnippet ifTrue: [ ^ anIndex ] ].
	^ nil
]

{ #category : #accessing }
GtLLepiterSnippetWithContent class >> snippetTypeOf: aSnippet [
	^ {LeTextSnippet -> 'text'.
		LePharoSnippet -> 'pharo'.
		LePythonSnippet -> 'python'.
		LeShellScriptSnippet -> 'shell'.
		LeExampleSnippet -> 'example'.
		LePictureSnippet -> 'picture'} asDictionary
		at: aSnippet class
		ifAbsent: [ aSnippet class name asString ]
]

{ #category : #printing }
GtLLepiterSnippetWithContent class >> viewTargetExcerptSize [
	"The number of characters of content that the views show for a changed snippet"

	^ 40
]

{ #category : #printing }
GtLLepiterSnippetWithContent class >> viewTargetOfType: aTypeString content: aContentString pageTitle: aTitleOrNil [
	"Return how the views name a changed snippet: its type, the start of its content on one line, and its page, such as 'pharo: 3 + 4 (page My page)'. The LLM JSON names a snippet by its ids instead"

	| excerpt |
	excerpt := ' ' join: (aContentString ifNil: [ '' ]) asString substrings.
	excerpt size > self viewTargetExcerptSize
		ifTrue: [ excerpt := (excerpt first: self viewTargetExcerptSize) , '...' ].
	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: (aTypeString ifNil: [ 'snippet' ]);
				nextPutAll: ': ';
				nextPutAll: excerpt.
			aTitleOrNil
				ifNotNil: [ :aTitle | 
					aStream
						nextPutAll: ' (page ';
						nextPutAll: aTitle;
						nextPut: $) ] ]
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> content [
	^ content
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> content: aSnippetContent [
	content := aSnippetContent
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> contentString [
	^ content ifNil: [ '' ] ifNotNil: [ :aContent | aContent contentString ]
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> databaseId [
	^ reference ifNotNil: [ :aReference | aReference databaseId ]
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> databaseName [
	^ databaseName
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> databaseName: aString [
	databaseName := aString
]

{ #category : #views }
GtLLepiterSnippetWithContent >> gtContentFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Content';
		priority: 5;
		text: [ self contentString ]
]

{ #category : #views }
GtLLepiterSnippetWithContent >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ {'Type' -> self snippetType.
				'Snippet uid' -> self snippetUid.
				'Page title' -> self pageTitle.
				'Page uid' -> self pageUid.
				'Database name' -> self databaseName.
				'Database id' -> self databaseId.
				'Parent snippet uid' -> self parentSnippetUid.
				'Position' -> self position.
				'Content' -> self content.
				'Reference' -> self reference} ];
		column: 'Property'
			text: [ :each | each key ]
			width: 150;
		column: 'Value' text: [ :each | each value ifNil: [ '' ] ];
		send: [ :each | each value ]
]

{ #category : #views }
GtLLepiterSnippetWithContent >> gtLiveSnippetFor: aView [
	"The snippet as it is now, not as I recorded it"

	<gtView>
	(reference notNil and: [ reference existsInLepiter ])
		ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Current snippet';
		priority: 15;
		object: [ reference ];
		view: #gtLiveSnippetFor:
]

{ #category : #printing }
GtLLepiterSnippetWithContent >> gtViewDescription [
	"Return how the views name me: my type, the start of my content and my page"

	^ self class
		viewTargetOfType: self snippetType
		content: self contentString
		pageTitle: self pageTitle
]

{ #category : #initialization }
GtLLepiterSnippetWithContent >> initializeFromSnippet: aSnippet [
	| aPage aParent |
	aPage := aSnippet page.
	reference := GtLLepiterSnippetReference fromSnippet: aSnippet.
	snippetType := self class snippetTypeOf: aSnippet.
	content := GtLLepiterSnippetContent fromSnippet: aSnippet.
	aPage
		ifNotNil: [ pageTitle := aPage title ifNotNil: [ :aTitle | aTitle asString copy ].
			databaseName := (GtLLepiterSnippetReference databaseNameOf: aPage database)
					ifNotNil: [ :aName | aName asString copy ].
			position := self class positionOf: aSnippet inPage: aPage ].
	aParent := aSnippet parent.
	parentSnippetUid := (aParent notNil and: [ aParent isSnippet ])
			ifTrue: [ aParent uid uidString ]
			ifFalse: [ nil ]
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> pageTitle [
	^ pageTitle
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> pageTitle: aString [
	pageTitle := aString
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> pageUid [
	^ reference ifNotNil: [ :aReference | aReference pageUid ]
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> parentSnippetUid [
	"Return the uid of the parent snippet, or nil for a snippet at the top of its page"

	^ parentSnippetUid
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> position [
	"Return the depth-first position of the snippet in its page: 1 for the first snippet"

	^ position
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> position: anInteger [
	position := anInteger
]

{ #category : #printing }
GtLLepiterSnippetWithContent >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				nextPutAll: (self snippetType ifNil: [ '' ]);
				nextPutAll: ' ';
				nextPutAll: (self snippetUid ifNil: [ '' ]);
				nextPutAll: ' in ';
				nextPutAll: (self pageTitle ifNil: [ 'no page' ]) ]
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> reference [
	^ reference
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> reference: aSnippetReference [
	reference := aSnippetReference
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> snippetType [
	"Return the type of the snippet, as the create tool names it (text, pharo, python, shell, example, picture), or its class name for the other types"

	^ snippetType
]

{ #category : #accessing }
GtLLepiterSnippetWithContent >> snippetUid [
	^ reference ifNotNil: [ :aReference | aReference snippetUid ]
]
