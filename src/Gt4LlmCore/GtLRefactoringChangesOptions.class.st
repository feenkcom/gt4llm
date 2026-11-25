"
I am the display options of the getRefactoringChanges tool ({{gtClass:GtLToolForRefactoringChanges}}): I list only the groups asked for, each from its offset and up to its limit ({{gtClass:GtLRefactoringChangesPage}}). The reports ({{gtClass:GtLRefactoringReport}}) read me as they read the display options of the other refactoring tools.
"
Class {
	#name : #GtLRefactoringChangesOptions,
	#superclass : #GtLRefactoringDisplayOptions,
	#instVars : [
		'pages'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #accessing }
GtLRefactoringChangesOptions >> displayOptionItems [
	^ {'includeSources' -> self includeSources}
		, (self pages associations
				collect: [ :each | 
					each key
						-> ('offset ' , each value normalizedOffset printString , ', limit '
								, each value normalizedLimit printString) ])
]

{ #category : #accessing }
GtLRefactoringChangesOptions >> includeChanges [
	"The changes are what is asked for"

	^ true
]

{ #category : #accessing }
GtLRefactoringChangesOptions >> limitOfGroup: aGroupName [
	^ (self pages at: aGroupName ifAbsent: [ ^ 0 ]) normalizedLimit
]

{ #category : #testing }
GtLRefactoringChangesOptions >> listsGroup: aGroupName [
	"Only the groups asked for are listed"

	^ self pages includesKey: aGroupName
]

{ #category : #accessing }
GtLRefactoringChangesOptions >> offsetOfGroup: aGroupName [
	^ (self pages at: aGroupName ifAbsent: [ ^ 0 ]) normalizedOffset
]

{ #category : #accessing }
GtLRefactoringChangesOptions >> pages [
	"The pages of the groups asked for, by the keys of the groups"

	^ pages ifNil: [ pages := OrderedDictionary new ]
]

{ #category : #accessing }
GtLRefactoringChangesOptions >> pages: aDictionary [
	pages := aDictionary
]

{ #category : #testing }
GtLRefactoringChangesOptions >> requestsGroup: aGroupName [
	^ self pages includesKey: aGroupName
]
