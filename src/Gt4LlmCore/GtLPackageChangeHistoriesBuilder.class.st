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
	#category : 'Gt4LlmCore-Summaries'
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

{ #category : #'building - private' }
GtLPackageChangeHistoriesBuilder >> addChangeFor: aCodeChange toGroups: groupedByPackageName [
	"Add a code change to the appropriate package groups.
	Method changes go to their method's package.
	Class changes may go to multiple packages (for moves)."
	
	aCodeChange isMethodChangeResult ifTrue: [
		self 
			addMethodChange: aCodeChange
			toGroups: groupedByPackageName.
		^ self ].
	
	aCodeChange isClassChangeResult ifTrue: [
		self 
			addClassChange: aCodeChange
			toGroups: groupedByPackageName.
		^ self ]
]

{ #category : #'private - building' }
GtLPackageChangeHistoriesBuilder >> addClassChange: aCodeChange toGroups: groupedByPackageName [
	"Add a class change to the appropriate package group."
	
	self 
		addCodeChange: aCodeChange
		toPackageNamed: aCodeChange changeResult affectedPackageName
		inGroups: groupedByPackageName
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

{ #category : #'building - private' }
GtLPackageChangeHistoriesBuilder >> addMethodChange: aCodeChange toGroups: groupedByPackageName [
	"Add a method change to its package group"
	| packageName changeResult methodReference |
	
	changeResult := aCodeChange changeResult.
	methodReference := changeResult targetMethodReference.
	
	"Get package name from the compiled method if it exists"
	packageName := methodReference 
		compiledMethodIfPresent: [ :cm | cm package packageName ]
		ifMissing: [ :error | 'Unknown' ].
	
	self 
		addCodeChange: aCodeChange
		toPackageNamed: packageName
		inGroups: groupedByPackageName
]

{ #category : #'building - private' }
GtLPackageChangeHistoriesBuilder >> buildClassHistoriesFor: aCollectionOfChanges forPackageNamed: aPackageName [
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
				GtLClassInPackageChangeHistory new
					targetClassName: className;
					targetPackageName: aPackageName;
					yourself ].
		
		"Get or create method history"
		methodHistory := methodHistoriesByReference
			at: methodReference
			ifAbsentPut: [ 
				| newHistory |
				newHistory := GtLMethodInPackageChangeHistory new
					methodReference: methodReference;
					targetPackageName: aPackageName;
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
				GtLClassInPackageChangeHistory new
					targetClassName: className;
					targetPackageName: aPackageName;
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

{ #category : #accessing }
GtLPackageChangeHistoriesBuilder >> codeChanges [
	^ codeChanges
]

{ #category : #accessing }
GtLPackageChangeHistoriesBuilder >> codeChanges: aCollection [
	codeChanges := aCollection
]

{ #category : #'building - private' }
GtLPackageChangeHistoriesBuilder >> createHistoryForPackageNamed: aPackageName fromChanges: aListOfChanges [
	"Create a package history with class histories from the given changes"
	^ GtLPackageChangeHistory new
		targetPackageName: aPackageName;
		addClassHistories: (self 
			buildClassHistoriesFor: aListOfChanges
			forPackageNamed: aPackageName)
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
