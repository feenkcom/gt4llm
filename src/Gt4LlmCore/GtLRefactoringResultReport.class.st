"
I report a {{gtClass:GtLRefactoringResult}}: what the applyRefactoring and renameClass tools answer. Unless the display options leave them out, I list the applied changes; after a failure I always list them, as they tell what was changed before the error. See {{gtClass:GtLRefactoringReport}}.
"
Class {
	#name : #GtLRefactoringResultReport,
	#superclass : #GtLRefactoringReport,
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #converting }
GtLRefactoringResultReport >> codeChangesJson [
	"Each code or Lepiter change with its kind and target, as the changes of a preview. A snippet removed with an ancestor is named in the removedChildSnippetUids of that ancestor"

	^ refactoring reportedChangeResults
		collect: [ :each | 
			| json |
			json := NeoJSONObject new
					at: 'kind' put: each llmChangeKind;
					at: 'target' put: each llmChangeTarget;
					yourself.
			each llmChangeEntry removedChildSnippetUids
				ifNotNil: [ :theUids | json at: 'removedChildSnippetUids' put: theUids ].
			json ]
		as: Array
]

{ #category : #views }
GtLRefactoringResultReport >> gtChangesFor: aView [
	"What the refactoring changed in the image"

	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Code changes';
		priority: 1;
		object: [ refactoring ];
		view: #gtChangesFor:
]

{ #category : #views }
GtLRefactoringResultReport >> gtRefactoringChangesFor: aView [
	"The changes of the preview that was applied"

	<gtView>
	<gtLlmView>
	refactoring preview ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Refactoring changes';
		priority: 2;
		object: [ refactoring ];
		view: #gtRefactoringChangesFor:
]

{ #category : #views }
GtLRefactoringResultReport >> gtStatusFor: aView [
	"Whether the refactoring was applied or failed, and why"

	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Status';
		priority: 3;
		object: [ refactoring ];
		view: #gtStatusFor:
]

{ #category : #testing }
GtLRefactoringResultReport >> includesChanges [
	"After a failure the changes are always listed: they tell what was changed before the error"

	^ displayOptions includeChanges or: [ refactoring hasFailed ]
]

{ #category : #testing }
GtLRefactoringResultReport >> listsChangesInGroups [
	^ self includesChanges and: [ super listsChangesInGroups ]
]

{ #category : #converting }
GtLRefactoringResultReport >> llmJsonObject [
	| json |
	json := NeoJSONObject new.
	json at: 'status' put: refactoring status.
	self addRefactoringPropertiesTo: json.
	refactoring objectId ifNotNil: [ :anId | json at: 'objectId' put: anId ].
	refactoring errorMessage
		ifNotNil: [ :aMessage | json at: 'errorMessage' put: aMessage ].
	self includesChanges ifFalse: [ ^ json ].
	changeGroups
		ifNil: [ json at: 'codeChanges' put: self codeChangesJson ]
		ifNotNil: [ changeGroups addJsonPropertiesTo: json ].
	^ json
]
