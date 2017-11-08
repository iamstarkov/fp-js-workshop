title: Semantic Awesomeness
style: ./semantic-awesomeness.css
controls: false

-- bg bg-intro
# Semantic Awesomeness

<br />
<center>
  <i>Merge to master and have a release</i>
  <br />
  <small>
    by [Vladimir Starkov](https://iamstarkov.com)
    <br>
    frontend engineer at [Nordnet Bank AB](https://www.nordnet.se/)
  </small>
</center>

-- bg bg-headaches
# Headaches

-- bg bg-mynameis
# My name is Vladimir Starkov

-- bg bg-problem
# Problem

-- bg bg-semver
# Semantic Versioning

--

### 1.0.0

* http://semver.org/
* MAJOR . MINOR . PATCH
* BREAKING . FEATURE . FIX

or

* MAJOR: intended
* MINOR: that was unexpected
* FIX: wow, who could thought of it

-- bg bg-history
# History

--

### History

* [_17 September, 2011:_ SemVer 1.0 was just born](https://github.com/mojombo/semver/releases/tag/v1.0.0)
* [_17 March, 2012:_ conventional changelog by angular.js](https://github.com/angular/angular.js/commit/4557881cf84f168855fc8615e174f24d6c2dd6ce#diff-69272c75604d89b2311fcf3a9d843ea3)
* [_18 June , 2013:_ SemVer 2.0 release](https://github.com/mojombo/semver/releases/tag/v2.0.0)
* Stephan Bönnemann is working on Hoodie
* [_1 August, 2014:_ grunt-release-hoodie](https://github.com/robinboehm/grunt-release-hoodie/commit/33118f3a866b06efe639a6c53737b3e86aff121d)
* [_3 September 2014:_ grunt-semantic-release](https://github.com/boennemann/grunt-semantic-release/commit/e85cae6f932ce88150e0025260e34d11755f8ab8)
* [_13 June 2015:_ semantic-release](https://github.com/semantic-release/semantic-release/commit/ac7037d9482a04fb97b39aaa928ca048090dd6a6)

-- bg bg-semantic-release
# Semantic release

--
### Semantic release

* https://github.com/semantic-release/semantic-release
* by [Stephan Bönnemann @boennemann](https://github.com/boennemann) (Hoodie, semantic-release, greenkeer.io)
* certain commit message format
* Changelog is derived from commit messages
* next version is derived from commit messages as well

--
### Semantic release
#### conventional format

```
type(scope?): short message

long description

BREAKING CHANGES or github/jira issues mentions
```

-- bg bg-practicalities
# Practicalities

--
### Practicalities
#### Prerequisites

1. Continuous Integration in place
2. _release-bot_ credentials:
  * SCM access
  * NPM registry

--
### Practicalities
#### Tool choice

* [semantic-release](https://github.com/semantic-release/semantic-release) for Travis + GitHub
* [corp-semantic-release](https://github.com/leonardoanalista/corp-semantic-release) for everything else

--
### Practicalities
#### Writing commit messages

[commitizen](https://github.com/commitizen/cz-cli) + [cz-conventional-changelog](https://github.com/commitizen/cz-conventional-changelog) config

```js
// ./package.json
"scripts": {
  "commit": "git-cz",
  // ...
},
"config": {
  "commitizen": {
    "path": "cz-conventional-changelog"
  }
},
```

--
### Practicalities
#### Writing commit messages

![](https://raw.githubusercontent.com/commitizen/cz-cli/master/meta/screenshots/add-commit.png)

--
### Practicalities
#### Validating commit messages

[husky](https://github.com/typicode/husky) + [@commitlint/{cli,config-angular}](https://github.com/marionebl/commitlint)

```js
// ./package.json
"scripts": {
  "commitmsg": "commitlint -e $GIT_PARAMS",
}

// commitlint.config.js
module.exports = { extends: [ '@commitlint/config-angular'] }
```

-- images

### Practicalities
#### Validating commit messages

Invalid:
![](https://i.imgur.com/mTjkpap.png)

Valid:
![](https://i.imgur.com/2uVkgwz.png)

--
### Practicalities
#### CI Integration

* run semantic-release only in master
* ignore commit message [ci-skip]
* ignore git tags
* ignore the release-bot

--

### Practicalities
#### semantic-release

```js
npm install --save-dev semantic-release

// ./.travis.yml
git config user.email "release-bot@localhost"
git config user.name "release-bot"
npm run build
npm run semantic-release

// ./package.json
"scripts": {
  "semantic-release": "semantic-release pre && npm publish && semantic-release post",
}
```

-- images

### Practicalities
#### semantic-release changelog

![](https://i.imgur.com/zg8T2sV.png)

--

### Practicalities
#### corp-semantic-release

```js
npm install --save-dev corp-semantic-release conventional-changelog-angular-bitbucket

// ./.travis.yml
git config user.email "release-bot@localhost"
git config user.name "release-bot"
git checkout master
npm run build
npm run semantic-release
npm publish

// ./package.json
"scripts": {
  "semantic-release": "corp-semantic-release --changelogpreset angular-bitbucket -v",
}
```

-- images

### Practicalities
#### semantic-release changelog

![](https://i.imgur.com/frf4HgR.png)


-- bg bg-summary
# Summary

-- bg bg-outro
# Semantic Awesomeness

<br />
<center>
  <i>In painless releases we trust</i>
  <br />
  <small>
    Sincerely yours [Vladimir Starkov](https://iamstarkov.com)  
    _@iamstarkov on [github](https://github.com/iamstarkov) and [twitter](https://twitter.com/iamstarkov)_
  </small>
</center>
