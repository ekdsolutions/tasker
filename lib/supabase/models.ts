export interface Label {
  id: string;
  user_id: string;
  text: string;
  color: string;
  created_at: string;
}

export interface SavedProduct {
  id: string;
  user_id: string;
  name: string;
  created_at: string;
}

export interface Product {
  id: string;
  board_id: string;
  name: string;
  started_date: string;
  period: 0.5 | 1 | 2 | 3;
  price: number;
  cost: number;
  sort_order: number;
  created_at: string;
  updated_at: string;
}

export interface Board {
  id: string;
  title: string;
  color: string;
  user_id: string;
  created_at: string;
  updated_at: string;
  total_value: number;
  upcoming_value: number;
  received_value: number;
  annual: number;
  started_date: string | null;
  notes: string | null;
  ending_date: string | null;
  sort_order: number;
  labels?: Label[];
  products?: Product[];
  totalTasks?: number;
}

export interface Column {
  id: string;
  board_id: string;
  title: string;
  sort_order: number;
  created_at: string;
  user_id: string;
}

export type ColumnWithTasks = Column & {
  tasks: Task[];
};

export interface Task {
  id: string;
  column_id: string;
  title: string;
  description: string | null;
  assignee: string | null;
  due_date: string | null;
  priority: "low" | "medium" | "high";
  sort_order: number;
  created_at: string;
}
