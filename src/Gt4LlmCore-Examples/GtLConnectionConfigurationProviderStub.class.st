"
A small provider used by GtLConnectionExamples to exercise connection configuration options without using real network providers.
"
Class {
	#name : #GtLConnectionConfigurationProviderStub,
	#superclass : #Object,
	#instVars : [
		'modelName',
		'baseUrl',
		'unaryOptionApplied',
		'defaultSetupApplied',
		'appliedOptions',
		'pairFirst',
		'pairSecond'
	],
	#category : #'Gt4LlmCore-Examples-Connection'
}

{ #category : #'instance creation' }
GtLConnectionConfigurationProviderStub class >> withDefaultSetup [
	^ self new
		markDefaultSetupApplied;
		yourself
]

{ #category : #accessing }
GtLConnectionConfigurationProviderStub >> appliedOptions [
	^ appliedOptions asArray
]

{ #category : #configuration }
GtLConnectionConfigurationProviderStub >> applyUnaryOption [
	unaryOptionApplied := true.
	appliedOptions add: #applyUnaryOption
]

{ #category : #accessing }
GtLConnectionConfigurationProviderStub >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
GtLConnectionConfigurationProviderStub >> baseUrl: aUrl [
	baseUrl := aUrl.
	appliedOptions add: #baseUrl -> aUrl
]

{ #category : #accessing }
GtLConnectionConfigurationProviderStub >> defaultSetupApplied [
	^ defaultSetupApplied
]

{ #category : #initialization }
GtLConnectionConfigurationProviderStub >> initialize [
	super initialize.
	appliedOptions := OrderedCollection new.
	unaryOptionApplied := false.
	defaultSetupApplied := false
]

{ #category : #configuration }
GtLConnectionConfigurationProviderStub >> markDefaultSetupApplied [
	defaultSetupApplied := true
]

{ #category : #accessing }
GtLConnectionConfigurationProviderStub >> modelName [
	^ modelName
]

{ #category : #accessing }
GtLConnectionConfigurationProviderStub >> modelName: aString [
	modelName := aString.
	appliedOptions add: #modelName -> aString
]

{ #category : #accessing }
GtLConnectionConfigurationProviderStub >> pairFirst [
	^ pairFirst
]

{ #category : #configuration }
GtLConnectionConfigurationProviderStub >> pairFirst: firstValue second: secondValue [
	pairFirst := firstValue.
	pairSecond := secondValue.
	appliedOptions add: #pair -> { firstValue. secondValue }
]

{ #category : #accessing }
GtLConnectionConfigurationProviderStub >> pairSecond [
	^ pairSecond
]

{ #category : #accessing }
GtLConnectionConfigurationProviderStub >> unaryOptionApplied [
	^ unaryOptionApplied
]
