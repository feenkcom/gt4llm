"
I build package change histories from summarizer code changes.

I am similar to {{gtClass:GtEpiceaPackagesHistoryBuilder}} but work with LLM tool call changes instead of Epicea entries.

Usage:
```
GtLPackageChangeHistoriesBuilder
	buildHistoryForCodeChanges: summarizer codeChanges
```
"
Class {
	#name : #GtLPackageChangeHistoriesBuilder,
	#superclass : #Object,
	#instVars : [
		'codeChanges'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #'instance creation' }
GtLPackageChangeHistoriesBuilder class >> buildHistoryForCodeChanges: aCodeChangesCollection [
	^ (self forCodeChanges: aCodeChangesCollection) buildHistory
]

{ #category : #'instance creation' }
GtLPackageChangeHistoriesBuilder class >> forCodeChanges: aCodeChangesCollection [
	^ self new 
		codeChanges: aCodeChangesCollection
]

{ #category : #'private - building' }
GtLPackageChangeHistoriesBuilder >> addChangeFor: aCodeChange toGroups: groupedByPackageName [
	"Add a code change to its affected package group."
	| changeResult |
	
	changeResult := aCodeChange changeResult.
	(changeResult isMethodChangeResult or: [ changeResult isClassChangeResult ]) ifTrue: [
		self 
			addCodeChange: aCodeChange
			toPackageNamed: changeResult affectedPackageName
			inGroups: groupedByPackageName ]
]

{ #category : #'building - private' }
GtLPackageChangeHistoriesBuilder >> addCodeChange: aCodeChange toPackageNamed: aPackageName inGroups: aDictionary [
	"Add a code change to the specified package group"
	| packageGroup |
	
	packageGroup := aDictionary 
		at: aPackageName 
		ifAbsentPut: [ GtLSummarizerCodeChangesGroup new ].
	
	packageGroup add: aCodeChange
]

{ #category : #'private - building' }
GtLPackageChangeHistoriesBuilder >> addExtraChangeForPackageMoveFor: aCodeChange toGroups: groupedByPackageName [
	"For class changes that represent a package move, also add the change to the old package."
	| changeResult |
	
	changeResult := aCodeChange changeResult.
	changeResult isClassModificationResult ifFalse: [ ^ self ].
	
	changeResult originalPackageName ifNil: [ ^ self ].
	changeResult originalPackageName = changeResult affectedPackageName ifTrue: [ ^ self ].
	
	self 
		addCodeChange: aCodeChange
		toPackageNamed: changeResult originalPackageName
		inGroups: groupedByPackageName
]

{ #category : #'private - building' }
GtLPackageChangeHistoriesBuilder >> buildClassHistoriesFor: aCollectionOfChanges forPackageNamed: aPackageName forPackageTagNamed: aPackageTagName [
	"Build class histories from the given changes, grouped by class name"
	| classHistoriesByClassName methodHistoriesByReference histories |
	
	classHistoriesByClassName := Dictionary new.
	methodHistoriesByReference := Dictionary new.
	
	"Process method changes"
	(aCollectionOfChanges select: [ :each | each isMethodChangeResult ]) do: [ :each |
		| changeResult methodReference className classHistory methodHistory |
		changeResult := each changeResult.
		methodReference := changeResult targetMethodReference.
		className := methodReference methodClassName.
		
		"Get or create class history"
		classHistory := classHistoriesByClassName
			at: className
			ifAbsentPut: [ 
				GtLClassInPackageTagChangeHistory new
					targetClassName: className;
					targetPackageName: aPackageName;
					targetPackageTagName: aPackageTagName;
					yourself ].
		
		"Get or create method history"
		methodHistory := methodHistoriesByReference
			at: methodReference
			ifAbsentPut: [ 
				| newHistory |
				newHistory := GtLMethodInPackageTagChangeHistory new
					methodReference: methodReference;
					targetPackageName: aPackageName;
					targetPackageTagName: aPackageTagName;
					yourself.
				classHistory addMethodHistory: newHistory.
				newHistory ].
		methodHistory addChange: each ].
	
	"Process class changes"
	(aCollectionOfChanges select: [ :each | each isClassChangeResult ]) do: [ :each |
		| changeResult className classHistory |
		changeResult := each changeResult.
		className := changeResult targetClassName asString.
		
		"Get or create class history"
		classHistory := classHistoriesByClassName
			at: className
			ifAbsentPut: [ 
				GtLClassInPackageTagChangeHistory new
					targetClassName: className;
					targetPackageName: aPackageName;
					targetPackageTagName: aPackageTagName;
					yourself ].
		
		classHistory addBehaviourChange: each ].
	
	histories := GtLClassChangeHistoriesGroup new.
	classHistoriesByClassName valuesDo: [ :each | histories addHistory: each ].
	^ histories
]

{ #category : #building }
GtLPackageChangeHistoriesBuilder >> buildHistory [
	"Build and return package histories from the code changes"
	| packagesHistory |
	packagesHistory := GtLPackageChangeHistoriesGroup new.
	
	self groupedByPackageName associations do: [ :assoc |
		packagesHistory addHistory: (self 
			createHistoryForPackageNamed: assoc key
			fromChanges: assoc value) ].
	
	^ packagesHistory
]

{ #category : #'private - building' }
GtLPackageChangeHistoriesBuilder >> buildPackageTagHistoriesFor: aCollectionOfChanges forPackageNamed: aPackageName [
	"Build package tag histories from the given changes, grouped by package tag name"
	| groupedByTagName histories |
	
	groupedByTagName := Dictionary new.
	
	"Group changes by package tag"
	aCollectionOfChanges do: [ :each |
		| tagName |
		tagName := each changeResult affectedPackageTagName.
		tagName ifNil: [ tagName := 'Unclassified' ].
		tagName ifEmpty: [ tagName := 'Unclassified' ].
		(groupedByTagName at: tagName ifAbsentPut: [ OrderedCollection new ]) add: each ].
	
	histories := GtLPackageTagChangeHistoriesGroup new.
	groupedByTagName keysAndValuesDo: [ :tagName :tagChanges |
		histories addHistory: (self 
			createHistoryForPackageTagNamed: tagName
			inPackageNamed: aPackageName
			fromChanges: tagChanges) ].
	^ histories
]

{ #category : #accessing }
GtLPackageChangeHistoriesBuilder >> codeChanges [
	^ codeChanges
]

{ #category : #accessing }
GtLPackageChangeHistoriesBuilder >> codeChanges: aCollection [
	codeChanges := aCollection
]

{ #category : #'private - building' }
GtLPackageChangeHistoriesBuilder >> createHistoryForPackageNamed: aPackageName fromChanges: aListOfChanges [
	"Create a package history with package tag histories from the given changes"
	^ GtLPackageChangeHistory new
		targetPackageName: aPackageName;
		addPackageTagHistories: (self 
			buildPackageTagHistoriesFor: aListOfChanges
			forPackageNamed: aPackageName)
]

{ #category : #'private - building' }
GtLPackageChangeHistoriesBuilder >> createHistoryForPackageTagNamed: aTagName inPackageNamed: aPackageName fromChanges: aListOfChanges [
	"Create a package tag history with class histories from the given changes"
	^ GtLPackageTagChangeHistory new
		targetPackageTagName: aTagName;
		addClassHistories: (self 
			buildClassHistoriesFor: aListOfChanges
			forPackageNamed: aPackageName
			forPackageTagNamed: aTagName)
]

{ #category : #'private - building' }
GtLPackageChangeHistoriesBuilder >> groupedByPackageName [
	"Group code changes by package name.
	For package moves, the change is added to both source and destination packages."
	| groupedByPackageName |
	groupedByPackageName := Dictionary new.
	
	self codeChanges do: [ :aCodeChange |
		self 
			addChangeFor: aCodeChange
			toGroups: groupedByPackageName.
		self
			addExtraChangeForPackageMoveFor: aCodeChange
			toGroups: groupedByPackageName ].
	
	^ groupedByPackageName
]
