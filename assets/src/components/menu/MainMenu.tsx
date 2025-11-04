import MainMenuItem from "@/components/menu/MainMenuItem"
import { Building, CircleGauge, Printer, Users } from "lucide-react"

interface Props {
  className?: string
}

export default function MainMenu({ className }: Props) {
  return (
    <div className={className}>
      <MainMenuItem text="Dashboard" link="/" icon={<CircleGauge size={20} />} />
      <MainMenuItem text="Organizations" link="/orgs" icon={<Building size={20} />} />
      <MainMenuItem text="Contacts" link="/contacts" icon={<Users size={20} />} />
      <MainMenuItem text="Reports" link="/reports" icon={<Printer size={20} />} />
    </div>
  )
}
