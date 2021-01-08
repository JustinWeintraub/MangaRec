// TODO: incomplete, implement with code
let dataset = {
  "Lisa Rose": {
    "Lady in the Water": 2.5,
    "Snakes on a Plane": 3.5,
    "Just My Luck": 3.0,
    "Superman Returns": 3.5,
    "You, Me and Dupree": 2.5,
    "The Night Listener": 3.0,
  },
  "Gene Seymour": {
    "Lady in the Water": 3.0,
    "Snakes on a Plane": 3.5,
    "Just My Luck": 1.5,
    "Superman Returns": 5.0,
    "The Night Listener": 3.0,
    "You, Me and Dupree": 3.5,
  },

  "Michael Phillips": {
    "Lady in the Water": 2.5,
    "Snakes on a Plane": 3.0,
    "Superman Returns": 3.5,
    "The Night Listener": 4.0,
  },
  "Claudia Puig": {
    "Snakes on a Plane": 3.5,
    "Just My Luck": 3.0,
    "The Night Listener": 4.5,
    "Superman Returns": 4.0,
    "You, Me and Dupree": 2.5,
  },

  "Mick LaSalle": {
    "Lady in the Water": 3.0,
    "Snakes on a Plane": 4.0,
    "Just My Luck": 2.0,
    "Superman Returns": 3.0,
    "The Night Listener": 3.0,
  },

  "Jack Matthews": {
    "Lady in the Water": 3.0,
    "Snakes on a Plane": 4.0,
    "The Night Listener": 3.0,
    "Superman Returns": 5.0,
    "You, Me and Dupree": 3.5,
  },

  Toby: {
    "Snakes on a Plane": 4.5,
    "You, Me and Dupree": 1.0,
    "Superman Returns": 4.0,
  },
};

// two scores to choose from
//calculate the euclidean distance btw two item
const euclidean_score = function (dataset, p1, p2) {
  //store item ining in both item
  //if dataset is in p1 and p2
  //store it in as one
  const inp1p2 = getIn(dataset, p1, p2);

  for (let key in dataset[p1]) {
    if (key in dataset[p2]) {
      inp1p2[key] = 1;
    }
  }
  if (Object.keys(inp1p2).length == 0) return 0; //check if it has a data
  const sum_of_euclidean_dist = []; //store the  euclidean distance

  //calculate the euclidean distance
  for (const item in dataset[p1]) {
    if (item in dataset[p2]) {
      sum_of_euclidean_dist.push(
        Math.pow(dataset[p1][item] - dataset[p2][item], 2)
      );
    }
  }
  let sum = 0;
  for (let i = 0; i < sum_of_euclidean_dist.length; i++) {
    sum += sum_of_euclidean_dist[i]; //calculate the sum of the euclidean
  }
  //since the sum will be small for familiar user
  // and larger for non-familiar user
  //we make it in btwn 0 and 1
  let sum_sqrt = 1 / (1 + Math.sqrt(sum));
  return sum_sqrt;
};

function getIn(dataset, p1, p2) {
  let inp1p2 = {};
  for (let item in dataset[p1]) {
    if (item in dataset[p2]) {
      inp1p2[item] = 1;
    }
  }
  return inp1p2;
}
function pearson_correlation(dataset, p1, p2) {
  // returns -1 to 1, -1 being far 1 being close
  const inp1p2 = getIn(dataset, p1, p2);
  let num_existence = Object.keys(inp1p2).length;
  if (num_existence == 0) return 0;
  //store the sum and the square sum of both p1 and p2
  //store the product of both
  let p1_sum = 0,
    p2_sum = 0,
    p1_sq_sum = 0,
    p2_sq_sum = 0,
    prod_p1p2 = 0;
  //calculate the sum and square sum of each data point
  //and also the product of both point
  for (let item in inp1p2) {
    p1_sum += dataset[p1][item];
    p2_sum += dataset[p2][item];
    p1_sq_sum += Math.pow(dataset[p1][item], 2);
    p2_sq_sum += Math.pow(dataset[p2][item], 2);
    prod_p1p2 += dataset[p1][item] * dataset[p2][item];
  }
  let numerator = prod_p1p2 - (p1_sum * p2_sum) / num_existence;
  let st1 = p1_sq_sum - Math.pow(p1_sum, 2) / num_existence;
  let st2 = p2_sq_sum - Math.pow(p2_sum, 2) / num_existence;
  let denominator = Math.sqrt(st1 * st2);
  if (denominator == 0) return 0;
  else {
    let val = numerator / denominator;
    return val;
  }
}
function similar_user(dataset, person, num_user, distance) {
  let scores = [];
  for (const others in dataset) {
    if (others != person && typeof dataset[others] != "function") {
      const val = distance(dataset, person, others);
      scores.push({ val: val, p: others });
    }
  }
  scores.sort(function (a, b) {
    return b.val < a.val ? -1 : b.val > a.val ? 1 : b.val >= a.val ? 0 : NaN;
  });
  const score = [];
  for (let i = 0; i < num_user; i++) {
    score.push(scores[i]);
  }
  return score;
}

var recommendation_eng = function (dataset, person, distance) {
  var totals = {
      //you can avoid creating a setter function
      //like this in the object you found them
      //since it just check if the object has the property if not create
      //and add the value to it.
      //and  because of this setter that why a function property
      // is created in the dataset, when we transform them.
      setDefault: function (props, value) {
        if (!this[props]) {
          this[props] = 0;
        }
        this[props] += value;
      },
    },
    simsum = {
      setDefault: function (props, value) {
        if (!this[props]) {
          this[props] = 0;
        }

        this[props] += value;
      },
    },
    rank_lst = [];
  for (var other in dataset) {
    if (other === person) continue;
    var similar = distance(dataset, person, other);

    if (similar <= 0) continue;
    for (var item in dataset[other]) {
      if (!(item in dataset[person]) || dataset[person][item] == 0) {
        //the setter help to make this look nice.
        totals.setDefault(item, dataset[other][item] * similar);
        simsum.setDefault(item, similar);
      }
    }
  }

  for (var item in totals) {
    //this what the setter function does
    //so we have to find a way to avoid the function in the object
    if (typeof totals[item] != "function") {
      var val = totals[item] / simsum[item];
      rank_lst.push({ val: val, items: item });
    }
  }
  rank_lst.sort(function (a, b) {
    return b.val < a.val ? -1 : b.val > a.val ? 1 : b.val >= a.val ? 0 : NaN;
  });
  var recommend = [];
  for (var i in rank_lst) {
    recommend.push(rank_lst[i].items);
  }
  return [rank_lst, recommend];
};
console.log(pearson_correlation(dataset, "Lisa Rose", "Jack Matthews"));

console.log(euclidean_score(dataset, "Lisa Rose", "Jack Matthews"));

console.log(similar_user(dataset, "Jack Matthews", 3, pearson_correlation));
console.log(recommendation_eng(dataset, "Jack Matthews", pearson_correlation));
