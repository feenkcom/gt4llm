"
I am what a refactoring tool answers: a report of a refactoring for the display options of the call. The refactoring, a preview ({{gtClass:GtLRefactoringPreview}}) or a result ({{gtClass:GtLRefactoringResult}}), keeps all its changes and is stored; I am not stored, and I choose what the response lists. My subclasses report a preview ({{gtClass:GtLRefactoringPreviewReport}}) and a result ({{gtClass:GtLRefactoringResultReport}}).

I write the response in `llmJsonObject`, which my LLM data view serializes; it includes the objectId of the refactoring:
- a refactoring that groups its changes, such as a class rename or a rewrite, is reported with a {{gtClass:GtLRefactoringChangeGroupsReport}}. It splits the change entries ({{gtClass:GtLRefactoringChangeEntry}}) into a class, method, Lepiter and other report, each limited by the display options. The Lepiter report groups its snippets by database, then by page;
- otherwise the changes are listed one by one, all of them.
Keys without a value are left out.

A tool call shows my views marked with gtLlmView. My subclasses link the gtLlmView views of their preview or result, only the ones that apply (for example the diff of a preview until it is applied, then its code changes); I add the response the agent got and its groups.
"
Class {
	#name : #GtLRefactoringReport,
	#superclass : #Object,
	#instVars : [
		'refactoring',
		'displayOptions',
		'changeGroups'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #'instance creation' }
GtLRefactoringReport class >> refactoring: aRefactoring displayOptions: aDisplayOptions [
	^ self new initializeRefactoring: aRefactoring displayOptions: aDisplayOptions
]

{ #category : #converting }
GtLRefactoringReport >> addRefactoringPropertiesTo: aJsonObject [
	refactoring refactoringName
		ifNotNil: [ :aName | aJsonObject at: 'refactoringName' put: aName ].
	refactoring refactoringDescription
		ifNotNil: [ :aDescription | aJsonObject at: 'refactoringDescription' put: aDescription ].
	aJsonObject at: 'changesCount' put: refactoring changesCount
]

{ #category : #accessing }
GtLRefactoringReport >> changeGroups [
	"Return the report of the groups of changes, or nil when the changes are not listed in groups"

	^ changeGroups
]

{ #category : #accessing }
GtLRefactoringReport >> displayOptions [
	^ displayOptions
]

{ #category : #views }
GtLRefactoringReport >> gtChangeGroupsFor: aView [
	"The groups of the response, each with all its entries and whether they were listed"

	<gtView>
	<gtLlmView>
	changeGroups ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Groups';
		priority: 51;
		object: [ changeGroups ];
		view: #gtGroupsFor:
]

{ #category : #views }
GtLRefactoringReport >> gtDisplayOptionsFor: aView [
	"The display options of the call, which decide what the response lists"

	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Display options';
		priority: 52;
		items: [ displayOptions displayOptionItems ];
		column: 'Option'
			text: [ :each | each key ]
			width: 150;
		column: 'Value' text: [ :each | each value printString ]
]

{ #category : #views }
GtLRefactoringReport >> gtJsonFor: aView [
	"What the agent got. The views of the report come after the ones of its preview or result"

	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Report JSON';
		priority: 50;
		object: [ self llmJsonObject asGtJson ];
		view: #gtJsonObjectFor:context:
]

{ #category : #initialization }
GtLRefactoringReport >> initializeRefactoring: aRefactoring displayOptions: aDisplayOptions [
	refactoring := aRefactoring.
	displayOptions := aDisplayOptions.
	changeGroups := self listsChangesInGroups
			ifTrue: [ GtLRefactoringChangeGroupsReport
					entries: aRefactoring changeEntries
					displayOptions: aDisplayOptions
					groupNames: aRefactoring changeGroupNames ]
]

{ #category : #testing }
GtLRefactoringReport >> listsChangesInGroups [
	^ refactoring groupsChanges
]

{ #category : #converting }
GtLRefactoringReport >> llmJsonObject [
	"Return what the tool answers, as a JSON object"

	^ self subclassResponsibility
]

{ #category : #views }
GtLRefactoringReport >> llmRawDataViewFor: aDataView [
	"What the agent gets: a tool answers me, built for the display options of its call"

	<gtLlmDataView>
	^ aDataView
		title: 'Refactoring report';
		jsonData: [ self llmJsonObject ]
]

{ #category : #printing }
GtLRefactoringReport >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [ aStream print: refactoring ]
]

{ #category : #accessing }
GtLRefactoringReport >> refactoring [
	"Return the preview or the result I report"

	^ refactoring
]
