"
I track method changes within a specific package context. This is useful for package-level grouping, especially for extension methods.

Instance variables:
- `targetPackageName` - the name of the package this method belongs to

See also:
- {{gtClass:GtEpiceaMethodInPackageHistory}} - similar concept in Epicea
"
Class {
	#name : #GtLMethodInPackageChangeHistory,
	#superclass : #GtLMethodChangeHistory,
	#instVars : [
		'targetPackageName'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #testing }
GtLMethodInPackageChangeHistory >> isInitialChangeAddition [
	"Check if this is an addition within the context of this package"
	^ super isInitialChangeAddition
]

{ #category : #testing }
GtLMethodInPackageChangeHistory >> isLatestChangeRemoval [
	"Check if this is a removal within the context of this package"
	^ super isLatestChangeRemoval
]

{ #category : #accessing }
GtLMethodInPackageChangeHistory >> targetPackageName [
	^ targetPackageName
]

{ #category : #accessing }
GtLMethodInPackageChangeHistory >> targetPackageName: aPackageName [
	targetPackageName := aPackageName
]
