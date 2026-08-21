"
Examples covering GtLConnection configuration options and their application to providers.
"
Class {
	#name : #GtLConnectionExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Connection'
}

{ #category : #'examples - connection' }
GtLConnectionExamples >> connectionAppliesConfigurationOptionsToBareProvider [
	<gtExample>
	<return: #GtLConnectionConfigurationProviderStub>
	| connection provider |
	connection := self connectionWithModelNameOption
		addOption: #baseUrl withValue: 'https://example.com';
		addOption: self unaryConfigurationOption;
		yourself.

	provider := connection buildBareProvider.

	self assert: provider defaultSetupApplied equals: false.
	self assert: provider modelName equals: 'example-model'.
	self assert: provider baseUrl equals: 'https://example.com'.
	self assert: provider unaryOptionApplied.
	self assert: provider appliedOptions equals: {
		#modelName -> 'example-model'.
		#baseUrl -> 'https://example.com'.
		#applyUnaryOption }.

	^ provider
]

{ #category : #'examples - connection' }
GtLConnectionExamples >> connectionBuildProviderStartsWithDefaultSetup [
	<gtExample>
	<return: #GtLConnectionConfigurationProviderStub>
	| connection provider |
	connection := self connectionWithModelNameOption
		addOption: #baseUrl withValue: 'https://example.com';
		yourself.

	provider := connection buildProvider.

	self assert: provider defaultSetupApplied.
	self assert: provider modelName equals: 'example-model'.
	self assert: provider baseUrl equals: 'https://example.com'.

	^ provider
]

{ #category : #'examples - connection' }
GtLConnectionExamples >> connectionRejectsDuplicateOptionNames [
	<gtExample>
	<return: #GtLConnection>
	| connection wasErrorRaised |
	connection := self connectionWithModelNameOption.
	wasErrorRaised := false.

	[ connection modelName: 'other-model' ]
		on: Error
		do: [ :anError | wasErrorRaised := true ].

	self assert: wasErrorRaised.
	self assert: connection modelName equals: 'example-model'.

	^ connection
]

{ #category : #'examples - connection' }
GtLConnectionExamples >> connectionWithModelNameOption [
	<gtExample>
	<return: #GtLConnection>
	| connection option |
	connection := GtLConnection new
		providerClass: GtLConnectionConfigurationProviderStub;
		modelName: 'example-model';
		yourself.

	option := connection optionNamed: #modelName.
	self assert: option class equals: GtLConnectionPropertyConfigurationOption.
	self assert: option name equals: #modelName.
	self assert: option selector equals: #modelName:.
	self assert: option values equals: { 'example-model' }.
	self assert: connection modelName equals: 'example-model'.

	^ connection
]

{ #category : #'examples - options' }
GtLConnectionExamples >> propertyConfigurationOption [
	<gtExample>
	<return: #GtLConnectionPropertyConfigurationOption>
	| option |
	option := GtLConnectionPropertyConfigurationOption
		name: #baseUrl
		selector: #baseUrl:
		valueGenerator: [ { 'https://example.com' } ].

	self assert: option name equals: #baseUrl.
	self assert: option selector equals: #baseUrl:.
	self assert: option values equals: { 'https://example.com' }.

	^ option
]

{ #category : #'examples - options' }
GtLConnectionExamples >> propertyConfigurationOptionWithMultipleArguments [
	<gtExample>
	<return: #GtLConnectionPropertyConfigurationOption>
	| option provider |
	option := GtLConnectionPropertyConfigurationOption
		name: #pair
		selector: #pairFirst:second:
		valueGenerator: [ { #one. #two } ].

	provider := GtLConnectionConfigurationProviderStub new.
	option applyOn: provider.

	self assert: provider pairFirst equals: #one.
	self assert: provider pairSecond equals: #two.
	self assert: provider appliedOptions equals: { #pair -> { #one. #two } }.

	^ option
]

{ #category : #'examples - options' }
GtLConnectionExamples >> unaryConfigurationOption [
	<gtExample>
	<return: #GtLConnectionUnaryConfigurationOption>
	| option provider |
	option := GtLConnectionUnaryConfigurationOption
		name: #'Apply unary option'
		selector: #applyUnaryOption.

	provider := GtLConnectionConfigurationProviderStub new.
	option applyOn: provider.

	self assert: option name equals: #'Apply unary option'.
	self assert: option selector equals: #applyUnaryOption.
	self assert: provider unaryOptionApplied.
	self assert: provider appliedOptions equals: { #applyUnaryOption }.

	^ option
]
