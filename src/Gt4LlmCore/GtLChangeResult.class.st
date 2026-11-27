"
I am the abstract superclass of the results that describe one change made by a tool or a refactoring: the code change results ({{gtClass:GtLCodeChangeResult}}) and the Lepiter snippet change results ({{gtClass:GtLLepiterSnippetChangeResult}}).

I hold the protocol that reports and views share:
- `llmChangeKind`, `llmChangeTarget` and `llmChangeEntry`, used by the refactoring reports ({{gtClass:GtLRefactoringResult}});
- `asDiffElement`, used by the applied diff of a refactoring change and the summaries;
- `gtViewChangeIcon`, with the shared icons on my class side;
- `isLepiterChangeResult`.

A result is built from snapshots and never holds the live method, class or snippet it describes.
"
Class {
	#name : #GtLChangeResult,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'accessing - icons' }
GtLChangeResult class >> additionIcon [
	^ self iconNamed: #changeAdd
]

{ #category : #'accessing - icons' }
GtLChangeResult class >> modificationIcon [
	^ self iconNamed: #changeUpdate
]

{ #category : #'accessing - icons' }
GtLChangeResult class >> removalIcon [
	^ self iconNamed: #changeRemove
]

{ #category : #converting }
GtLChangeResult >> asDiffElement [
	"Return an element showing the diff from the old to the new state"

	^ self subclassResponsibility
]

{ #category : #views }
GtLChangeResult >> gtViewChangeIcon [
	"Return the icon of my kind of change: one of the icons on my class side"

	^ self subclassResponsibility
]

{ #category : #views }
GtLChangeResult >> gtViewChangeTarget [
	"Return how the views name what changed. By default my llmChangeTarget, the identifier that the refactoring reports give"

	^ self llmChangeTarget
]

{ #category : #testing }
GtLChangeResult >> isErrorDomainObject [
	^ false
]

{ #category : #testing }
GtLChangeResult >> isLepiterChangeResult [
	"Return true if I describe the change of a Lepiter snippet"

	^ false
]

{ #category : #refactoring }
GtLChangeResult >> llmChangeEntry [
	"Return the entry that lists me in the groups of changes of an applied refactoring"

	^ self subclassResponsibility
]

{ #category : #refactoring }
GtLChangeResult >> llmChangeKind [
	"Return a short label of what changed, such as 'added method' or 'modified snippet'"

	^ self subclassResponsibility
]

{ #category : #refactoring }
GtLChangeResult >> llmChangeTarget [
	"Return the method signature, class name or snippet that changed"

	^ self subclassResponsibility
]
