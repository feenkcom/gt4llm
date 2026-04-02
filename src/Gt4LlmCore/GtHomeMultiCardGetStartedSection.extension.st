Extension { #name : #GtHomeMultiCardGetStartedSection }

{ #category : #'*Gt4LlmCore' }
GtHomeMultiCardGetStartedSection >> gtLlmCard [
	<gtSectionCard>
	<gtExample>
	<noTest>
	GtLConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ GtHomeCard empty ].

	^ GtHomeCard explicit
		priority: 50;
		stencil: [ | anElement |
			anElement := GtLChatRegistryElement new.
			anElement
				withDeselectionOnSpawnEvents;
				registryViewModel: GtL registry asViewModel;
				background: anElement theme default contentBackground;
				addAptitude: BrShadowAptitude new beLarge;
				addAptitude: (BrGlamorousWithHorizontalResizerAptitude new
						beRight;
						resizerDo: [ :aResizer | 
							anElement
								addAptitude: (BrLazyStyleCommonAptitude new
										default: [ :aStyle | aStyle do: [ :aWidget | aResizer visibility: BlVisibility hidden ] ];
										hovered: [ :aStyle | 
											aStyle
												do: [ :aWidget | aResizer visibility: BlVisibility visible ]
												after: [ :aWidget | aResizer visibility: BlVisibility hidden ] ]) ]);
				addAptitude: (BrGlamorousWithVerticalResizerAptitude new
						beBottom;
						resizerDo: [ :aResizer | 
							anElement
								addAptitude: (BrLazyStyleCommonAptitude new
										default: [ :aStyle | aStyle do: [ :aWidget | aResizer visibility: BlVisibility hidden ] ];
										hovered: [ :aStyle | 
											aStyle
												do: [ :aWidget | aResizer visibility: BlVisibility visible ]
												after: [ :aWidget | aResizer visibility: BlVisibility hidden ] ]) ]);
				addAptitude: (GtPhlowBrowseDefinitionAptitude new
						definition: [ GtHomeMultiCardGetStartedSection >> #gtLlmCard ]);
				hExact: 350;
				vExact: 400;
				padding: (BlInsets
						top: 10
						left: 10
						bottom: 10
						right: 0);
				margin: (BlInsets
						top: self spaceGap
						left: 2 * self spaceGap
						bottom: 2 * self spaceGap
						right: 2 * self spaceGap).

			BlTaskAction
				enqueueElement: anElement
				action: [ anElement
						withAllParentsDetect: [ :eachParent | eachParent isKindOf: GtWorldElement ]
						ifFound: [ :aWorldElement | 
							GtLWorldRegistrySubscriptionHandler new
								subscribeInWordElement: aWorldElement
								forRegistryElement: anElement ]
						ifNone: [  ] ].

			anElement ]
]
