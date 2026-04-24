"
I track method changes within a specific package tag context.

Instance variables:
- `targetPackageName` - the name of the package this method belongs to
- `targetPackageTagName` - the name of the package tag this method belongs to

See also:
- {{gtClass:GtLMethodInPackageChangeHistory}} - similar but at package level
"
Class {
	#name : #GtLMethodInPackageTagChangeHistory,
	#superclass : #GtLMethodChangeHistory,
	#instVars : [
		'targetPackageName',
		'targetPackageTagName'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #testing }
GtLMethodInPackageTagChangeHistory >> isInitialChangeAddition [
	"Check if this is an addition within the context of this package tag"
	^ super isInitialChangeAddition
]

{ #category : #testing }
GtLMethodInPackageTagChangeHistory >> isLatestChangeRemoval [
	"Check if this is a removal within the context of this package tag"
	^ super isLatestChangeRemoval
]

{ #category : #accessing }
GtLMethodInPackageTagChangeHistory >> targetPackageName [
	^ targetPackageName
]

{ #category : #accessing }
GtLMethodInPackageTagChangeHistory >> targetPackageName: aString [
	targetPackageName := aString
]

{ #category : #accessing }
GtLMethodInPackageTagChangeHistory >> targetPackageTagName [
	^ targetPackageTagName
]

{ #category : #accessing }
GtLMethodInPackageTagChangeHistory >> targetPackageTagName: aString [
	targetPackageTagName := aString
]
