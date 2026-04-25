"
I track class changes within a specific package tag context. This is useful for package tag-level grouping where a class might be associated with a particular package tag.

Instance variables:
- `targetPackageName` - the name of the package this class belongs to
- `targetPackageTagName` - the name of the package tag this class belongs to

See also:
- {{gtClass:GtEpiceaClassInPackageHistory}} - similar concept in Epicea
"
Class {
	#name : #GtLClassInPackageTagChangeHistory,
	#superclass : #GtLClassChangeHistory,
	#instVars : [
		'targetPackageName',
		'targetPackageTagName'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLClassInPackageTagChangeHistory class >> methodHistoryType [
	^ GtLMethodInPackageTagChangeHistory
]

{ #category : #testing }
GtLClassInPackageTagChangeHistory >> isInitialDefinitionChangeAddition [
	"Check if this is an addition within the context of this package tag.
	A class is considered 'added' to this package tag if:
	1. It was truly created (no original class), OR
	2. It was moved INTO this package tag from another package/tag"
	
	super isInitialDefinitionChangeAddition ifTrue: [ ^ true ].
	self behaviourChanges ifEmpty: [ ^ false ].
	
	^ self 
			isPackageTagMoveFor: self behaviourChangeHistory initialChange changeResult 
			toTarget: true
]

{ #category : #testing }
GtLClassInPackageTagChangeHistory >> isLatestDefinitionChangeRemoval [
	"Check if this is a removal within the context of this package tag.
	A class is considered 'removed' from this package tag if:
	1. It was truly removed from the system, OR
	2. It was moved OUT OF this package tag to another package/tag"
	
	super isLatestDefinitionChangeRemoval ifTrue: [ ^ true ].
	self behaviourChanges ifEmpty: [ ^ false ].
	
	^ self 
			isPackageTagMoveFor: self behaviourChangeHistory latestChange changeResult 
			toTarget: false
]

{ #category : #private }
GtLClassInPackageTagChangeHistory >> isPackageTagMoveFor: aChangeResult toTarget: isToTarget [
	"Check if aChangeResult represents a package/tag move.
	If isToTarget is true, check if moving INTO this package tag.
	If isToTarget is false, check if moving OUT OF this package tag."
	| oldPackage newPackage oldTag newTag targetPackage targetTag |
	
	aChangeResult isClassModificationResult ifFalse: [ ^ false ].
	
	oldPackage := aChangeResult originalClass packageName.
	newPackage := aChangeResult updatedClass packageName.
	oldTag := aChangeResult originalClass packageTagName.
	newTag := aChangeResult updatedClass packageTagName.
	
	"No move if package and tag are unchanged"
	(oldPackage = newPackage and: [ oldTag = newTag ]) ifTrue: [ ^ false ].
	
	"Check the appropriate side based on direction"
	targetPackage := isToTarget ifTrue: [ newPackage ] ifFalse: [ oldPackage ].
	targetTag := isToTarget ifTrue: [ newTag ] ifFalse: [ oldTag ].
	
	^ targetPackage = self targetPackageName 
		and: [ targetTag = self targetPackageTagName ]
]

{ #category : #accessing }
GtLClassInPackageTagChangeHistory >> targetPackageName [
	^ targetPackageName
]

{ #category : #accessing }
GtLClassInPackageTagChangeHistory >> targetPackageName: aString [
	targetPackageName := aString
]

{ #category : #accessing }
GtLClassInPackageTagChangeHistory >> targetPackageTagName [
	^ targetPackageTagName
]

{ #category : #accessing }
GtLClassInPackageTagChangeHistory >> targetPackageTagName: aString [
	targetPackageTagName := aString
]
