"
I track class changes within a specific package context. This is useful for package-level grouping where a class might be associated with a particular package even after it's been removed.

Instance variables:
- `targetPackageName` - the name of the package this class belongs to

See also:
- {{gtClass:GtEpiceaClassInPackageHistory}} - similar concept in Epicea
"
Class {
	#name : #GtLClassInPackageChangeHistory,
	#superclass : #GtLClassChangeHistory,
	#instVars : [
		'targetPackageName'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #'instance creation' }
GtLClassInPackageChangeHistory class >> methodHistoryType [
	^ GtLMethodInPackageChangeHistory
]

{ #category : #testing }
GtLClassInPackageChangeHistory >> isInitialDefinitionChangeAddition [
	"Check if this is an addition within the context of this package.
	A class is considered 'added' to this package if:
	1. It was truly created (no original class), OR
	2. It was moved INTO this package from another package (package name change)"
	| initialChange changeResult |
	
	super isInitialDefinitionChangeAddition ifTrue: [ ^ true ].
	
	self behaviourChanges ifEmpty: [ ^ false ].
	initialChange := self behaviourChangeHistory initialChange.
	changeResult := initialChange changeResult.
	
	"Package change - class moved INTO this package"
	changeResult isClassModificationResult ifTrue: [
		| oldPackage newPackage |
		oldPackage := changeResult originalClass packageName.
		newPackage := changeResult updatedClass packageName.
		^ oldPackage ~= newPackage and: [ newPackage = self targetPackageName ] ].
	
	^ false
]

{ #category : #testing }
GtLClassInPackageChangeHistory >> isLatestDefinitionChangeRemoval [
	"Check if this is a removal within the context of this package.
	A class is considered 'removed' from this package if:
	1. It was truly removed from the system, OR
	2. It was moved OUT OF this package to another package (package name change)"
	| latestChange changeResult |
	
	super isLatestDefinitionChangeRemoval ifTrue: [ ^ true ].
	
	self behaviourChanges ifEmpty: [ ^ false ].
	latestChange := self behaviourChangeHistory latestChange.
	changeResult := latestChange changeResult.
	
	"Package change - class moved OUT OF this package"
	changeResult isClassModificationResult ifTrue: [
		| oldPackage newPackage |
		oldPackage := changeResult originalClass packageName.
		newPackage := changeResult updatedClass packageName.
		^ oldPackage ~= newPackage and: [ oldPackage = self targetPackageName ] ].
	
	^ false
]

{ #category : #accessing }
GtLClassInPackageChangeHistory >> targetPackageName [
	^ targetPackageName
]

{ #category : #accessing }
GtLClassInPackageChangeHistory >> targetPackageName: aPackageName [
	targetPackageName := aPackageName.
	self methodHistories items do: [ :aMethodHistory |
		(aMethodHistory respondsTo: #targetPackageName:) ifTrue: [
			aMethodHistory targetPackageName: aPackageName ] ]
]
