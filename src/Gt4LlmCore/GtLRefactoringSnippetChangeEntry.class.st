"
I list a changed Lepiter snippet by its uid. I hold no snippet, only the values recorded when I was made: the database id and name, the page uid and title, the depth-first position of the snippet in its page, and its uid. The Lepiter report groups and orders us by these values ({{gtClass:GtLRefactoringLepiterChangesReport}}).

- A previewed change gives me from the location of its snippet when the preview is made ({{gtMethod:GtLRefactoringSnippetChangeEntry class>>#fromSnippet:}});
- an applied change gives me from the snapshot of its snippet change result ({{gtMethod:GtLRefactoringSnippetChangeEntry class>>#fromSnippetWithContent:}}).
"
Class {
	#name : #GtLRefactoringSnippetChangeEntry,
	#superclass : #GtLRefactoringChangeEntry,
	#instVars : [
		'databaseId',
		'databaseName',
		'pageUid',
		'pageTitle',
		'position',
		'snippetUid'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #'instance creation' }
GtLRefactoringSnippetChangeEntry class >> fromSnippet: aSnippet [
	"An entry of a previewed change: the location of the snippet when the preview is made"

	^ self fromSnippet: aSnippet inPage: aSnippet page
]

{ #category : #'instance creation' }
GtLRefactoringSnippetChangeEntry class >> fromSnippet: aSnippet inPage: aPageOrNil [
	^ self new
		initializeFromSnippet: aSnippet inPage: aPageOrNil;
		yourself
]

{ #category : #'instance creation' }
GtLRefactoringSnippetChangeEntry class >> fromSnippetWithContent: aSnippetWithContent [
	"An entry of an applied change, from the snapshot of its result"

	^ self new
		initializeFromSnippetWithContent: aSnippetWithContent;
		yourself
]

{ #category : #converting }
GtLRefactoringSnippetChangeEntry >> addTargetPropertiesTo: aJsonObject [
	self snippetUid ifNotNil: [ :anUid | aJsonObject at: 'snippetUid' put: anUid ]
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> databaseId [
	"The id of the database (base 36), or nil for an in-memory database"

	^ databaseId
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> databaseId: aStringOrNil [
	databaseId := aStringOrNil
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> databaseName [
	^ databaseName
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> databaseName: aStringOrNil [
	databaseName := aStringOrNil
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> groupKind [
	^ #lepiter
]

{ #category : #views }
GtLRefactoringSnippetChangeEntry >> gtLiveSnippetFor: aView [
	"The snippet as it is now. Empty for a snippet that was not added yet or that no longer resolves"

	<gtView>
	(self snippetReference
		ifNil: [ false ]
		ifNotNil: [ :aReference | aReference existsInLepiter ])
		ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Current snippet';
		priority: 15;
		object: [ self snippetReference ];
		view: #gtLiveSnippetFor:
]

{ #category : #initialization }
GtLRefactoringSnippetChangeEntry >> initializeFromSnippet: aSnippet inPage: aPageOrNil [
	"Record where the snippet is now. A snippet that is not added yet has no uid and no position"

	databaseId := aPageOrNil
			ifNotNil: [ :aPage | GtLLepiterSnippetReference databaseIdOf: aPage database ].
	databaseName := aPageOrNil
			ifNotNil: [ :aPage | GtLLepiterSnippetReference databaseNameOf: aPage database ].
	pageUid := aPageOrNil ifNotNil: [ :aPage | aPage uidString ].
	pageTitle := aPageOrNil ifNotNil: [ :aPage | aPage title ].
	position := aPageOrNil
			ifNotNil: [ :aPage | GtLLepiterSnippetWithContent positionOf: aSnippet inPage: aPage ].
	snippetUid := aSnippet uid ifNotNil: [ :anUid | anUid uidString ]
]

{ #category : #initialization }
GtLRefactoringSnippetChangeEntry >> initializeFromSnippetWithContent: aSnippetWithContent [
	databaseId := aSnippetWithContent databaseId.
	databaseName := aSnippetWithContent databaseName.
	pageUid := aSnippetWithContent pageUid.
	pageTitle := aSnippetWithContent pageTitle.
	position := aSnippetWithContent position.
	snippetUid := aSnippetWithContent snippetUid
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> pageTitle [
	^ pageTitle
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> pageTitle: aStringOrNil [
	pageTitle := aStringOrNil
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> pageUid [
	"The form getLepiterPageContents and editLepiterSnippets expect"

	^ pageUid
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> pageUid: aStringOrNil [
	pageUid := aStringOrNil
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> position [
	"The depth-first position of the snippet in its page, or nil"

	^ position
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> position: anIntegerOrNil [
	position := anIntegerOrNil
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> snippetReference [
	"Return the reference of the snippet, from the recorded ids, or nil for a snippet that was not added yet"

	snippetUid ifNil: [ ^ nil ].
	^ GtLLepiterSnippetReference new
		databaseId: databaseId;
		pageUid: pageUid;
		snippetUid: snippetUid;
		yourself
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> snippetUid [
	"The form editLepiterSnippets expects; nil for a snippet that is not added yet"

	^ snippetUid
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> snippetUid: aStringOrNil [
	snippetUid := aStringOrNil
]

{ #category : #accessing }
GtLRefactoringSnippetChangeEntry >> target [
	^ self snippetUid ifNil: [ 'new snippet' ]
]
