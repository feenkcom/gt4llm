"
I split the change entries ({{gtClass:GtLRefactoringChangeEntry}}) of a refactoring into reports of class, method, Lepiter snippet and other changes, each limited by the display options. The groups the refactoring covers (my groupNames) are written in the JSON also when they are empty, so that an empty group tells that nothing of that kind changed; the other groups are written only when they have changes.
"
Class {
	#name : #GtLRefactoringChangeGroupsReport,
	#superclass : #Object,
	#instVars : [
		'classChanges',
		'methodChanges',
		'lepiterChanges',
		'otherChanges',
		'groupNames',
		'displayOptions'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #'instance creation' }
GtLRefactoringChangeGroupsReport class >> entries: aCollectionOfChangeEntries displayOptions: aDisplayOptions groupNames: anArray [
	^ self new
		initializeEntries: aCollectionOfChangeEntries
		displayOptions: aDisplayOptions
		groupNames: anArray
]

{ #category : #converting }
GtLRefactoringChangeGroupsReport >> addJsonPropertiesTo: aJsonObject [
	"Add the groups the display options list: the ones the refactoring covers, also when they are empty, the other groups that have changes, and the ones asked for explicitly"

	self groupsByKey
		do: [ :each | 
			((displayOptions listsGroup: each key)
				and: [ (groupNames includes: each key)
						or: [ each value isEmpty not or: [ displayOptions requestsGroup: each key ] ] ])
				ifTrue: [ aJsonObject at: each key put: each value llmJsonObject ] ]
]

{ #category : #accessing }
GtLRefactoringChangeGroupsReport >> classChanges [
	^ classChanges
]

{ #category : #accessing }
GtLRefactoringChangeGroupsReport >> groupsByKey [
	"Return my groups with their JSON keys"

	^ {'classChanges' -> classChanges.
		'methodChanges' -> methodChanges.
		'lepiterChanges' -> lepiterChanges.
		'otherChanges' -> otherChanges}
]

{ #category : #views }
GtLRefactoringChangeGroupsReport >> gtGroupsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Groups';
		priority: 1;
		items: [ self groupsByKey ];
		column: 'Group'
			text: [ :each | each key ]
			width: 150;
		column: 'Report' text: [ :each | each value printString ];
		send: [ :each | each value ]
]

{ #category : #initialization }
GtLRefactoringChangeGroupsReport >> initializeEntries: aCollectionOfChangeEntries displayOptions: aDisplayOptions groupNames: anArray [
	| entriesByGroup groupReport |
	groupNames := anArray.
	displayOptions := aDisplayOptions.
	self useNewClassNamesIn: aCollectionOfChangeEntries.
	entriesByGroup := aCollectionOfChangeEntries
			groupedBy: [ :each | each groupKind ].
	groupReport := [ :aReportClass :aGroupKind :aGroupName | 
		aReportClass
			entries: (entriesByGroup at: aGroupKind ifAbsent: [ #() ])
			offset: (aDisplayOptions offsetOfGroup: aGroupName)
			limit: (aDisplayOptions limitOfGroup: aGroupName)
			includeSources: aDisplayOptions includeSources ].
	classChanges := groupReport
			value: GtLRefactoringClassChangesReport
			value: #class
			value: 'classChanges'.
	methodChanges := groupReport
			value: GtLRefactoringMethodChangesReport
			value: #method
			value: 'methodChanges'.
	lepiterChanges := groupReport
			value: GtLRefactoringLepiterChangesReport
			value: #lepiter
			value: 'lepiterChanges'.
	otherChanges := groupReport
			value: GtLRefactoringOtherChangesReport
			value: #other
			value: 'otherChanges'
]

{ #category : #accessing }
GtLRefactoringChangeGroupsReport >> lepiterChanges [
	^ lepiterChanges
]

{ #category : #accessing }
GtLRefactoringChangeGroupsReport >> methodChanges [
	^ methodChanges
]

{ #category : #accessing }
GtLRefactoringChangeGroupsReport >> otherChanges [
	^ otherChanges
]

{ #category : #printing }
GtLRefactoringChangeGroupsReport >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				print: classChanges totalCount;
				nextPutAll: ' classes, ';
				print: methodChanges totalCount;
				nextPutAll: ' methods, ';
				print: lepiterChanges totalSnippetsCount;
				nextPutAll: ' snippets, ';
				print: otherChanges totalCount;
				nextPutAll: ' other' ]
]

{ #category : #private }
GtLRefactoringChangeGroupsReport >> useNewClassNamesIn: aCollectionOfChangeEntries [
	"The changes of a renamed class are listed under its new name, also those made before the rename in the same refactoring, such as a removed method"

	| newNames |
	newNames := Dictionary new.
	aCollectionOfChangeEntries
		do: [ :each | 
			(each groupKind = #class and: [ each isRename ])
				ifTrue: [ newNames at: each className put: each newClassName ] ].
	aCollectionOfChangeEntries do: [ :each | each useNewClassNames: newNames ]
]
