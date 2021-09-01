## [2.1.0]

- update dependencies

## [2.0.0]

- null safety

## [1.1.0]

- update dependencies

## [1.0.1]

- lint fixes

## [1.0.0]

- Breaking Change: Now use BuiltStep.findAssets to let build_runner watch the consumed files for changes!
  This means that the caches are properly invalidated on changes! But this also means that only files under /lib can be found, so this is a breaking change:
  if you stored your config.json files outside of lib/ the will not be found anymore!
  
- fixed deprecated analyzer fields/methods
    

## [0.5.0]

Add better error messages

Update dependency versions

## [0.4.0+1]

Lint fixes

## [0.4.0]

Use analyzer ^0.39.0.

## [0.3.0]

Use analyzer ^0.38.0 and newer source\_gen versions. built\_value and json\_serializable support this version by now.

## [0.2.0]

Use analyzer ^0.36.4 in order to be compatible to built\_value

## [0.1.0] 

Use analyzer >= 0.37.0


